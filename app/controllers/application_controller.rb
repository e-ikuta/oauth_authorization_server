class ApplicationController < ActionController::Base
  skip_before_action :verify_authenticity_token, only: [:token]

  def error; end

  def authorize
    @client = Client.find_by(client_id: params[:client_id])

    if @client.blank?
      logger.info("Unknown client #{params[:client_id]}")
      flash.now[:error] = "Unknown client"
      render :error and return
    end

    redirect_uri = @client.redirect_uris.find_by(uri: params[:redirect_uri])

    if redirect_uri.blank?
      logger.info("Mismatched redirect URI, expected #{@client.redirect_uris} got #{redirect_uri}")
      flash.now[:error] = "Invalid redirect URI"
      render :error and return
    end

    rscope = params[:scope].present? ? params[:scope].split(" ") : []
    cscope = @client.scopes.pluck(:name)

    if rscope.difference(cscope).size > 0
      redirect_to "#{params[:redirect_uri]}?error=invalid_scope" and return
    end

    @scopes = rscope

    session[:request_params] = {
      client_id: params[:client_id],
      redirect_uri: params[:redirect_uri],
      state: params[:state],
      response_type: params[:response_type],
    }
  end

  def approve
    request_params = session[:request_params]
    session[:request_params] = nil

    if request_params.blank?
      flash.now[:error] = "No matching authorization request"
      render :error and return
    end

    request_params.deep_symbolize_keys!

    if params[:deny].present?
      redirect_to "#{request_params[:redirect_uri]}?error=access_denied" and return
    end

    if request_params[:response_type] != "code"
      redirect_to "#{request_params[:redirect_uri]}?error=unsupported_response_type" and return
    end

    client = Client.find_by(client_id: request_params[:client_id])
    rscope = params[:approve].present? ? params[:approve].select {|_,v| v == "1"}.keys : []
    cscope = client.scopes.pluck(:name)

    if rscope.difference(cscope).size > 0
      redirect_to "#{request_params[:redirect_uri]}?error=invalid_scope" and return
    end

    code = SecureRandom.alphanumeric

    code_credentials = client.code_credentials.create!(
      code: code,
    )

    code_credentials.approved_scopes.create!(
      rscope.map { |name| { scope: Scope.find_by(name: name) }}
    )

    redirect_to "#{request_params[:redirect_uri]}?code=#{code}&state=#{request_params[:state]}"
  end

  def token
    auth = request.headers["authorization"]

    if auth.present?
      raw_auth = Base64.decode64(auth)
      client_credentials = raw_auth['basic '.length, raw_auth.length].split(":")
      client_id = client_credentials[0]
      client_secret = client_credentials[1]
    end

    request_params = JSON.parse(request.body.string).deep_symbolize_keys

    if request_params[:client_id].present?
      if client_id.present?
        logger.info("Client attempted to authenticate with multiple methods")
        render json: {error: "invalid_client"}, status: 401 and return
      else
        client_id = request_params[:client_id]
        client_secret = request_params[:client_secret]
      end
    end

    client = Client.find_by(client_id: client_id)

    if client.blank?
      logger.info("Unknown client #{client_id}")
      render json: {error: "invalid_client"}, status: 401 and return
    end

    if client.client_secret != client_secret
      logger.info("Mismatched client secret, expected #{client.client_secret} got #{client_secret}")
      render json: {error: "invalid_client"}, status: 401 and return
    end

    if request_params[:grant_type] == "authorization_code"

      begin
        code_credentials = CodeCredential.find_by!(code: request_params[:code])
      rescue ActiveRecord::RecordNotFound
        logger.info("Unknown code, #{request_params[:code]}")
        render json: {error: "invalid_grant"}, status: 400 and return
      end

      access_token = SecureRandom.alphanumeric
      refresh_token = SecureRandom.alphanumeric

      # DBにデータ突っ込む

      token_reponse = {
        access_token: access_token,
        token_type: "Bearer",
        refresh_token: refresh_token,
        scope: code_credentials.scopes.pluck(:name).join(" "),
      }
      render json: token_reponse, status: 200

      code_credentials.destroy

    elsif request_params[:grant_type] == "refresh_token"

      # issue refresh token

    else

      logger.info("Unknown grant type #{request_params[:grant_type]}")
      render json: {error: "unsupported_grant_type"}, status: 400

    end
  end
end
