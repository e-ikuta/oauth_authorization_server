require "test_helper"

class ClientTest < ActiveSupport::TestCase
  test "has many redirect_uris" do
    expected = [redirect_uris(:sample_uri_1), redirect_uris(:sample_uri_2)]
    actual = clients(:sample_client).redirect_uris.to_a
    assert_equal [], expected - actual
  end

  test "has many scopes" do
    expected = [scopes(:foo), scopes(:bar)]
    actual = clients(:sample_client).scopes.to_a
    assert_equal [], expected - actual
  end

  test "has many code_credentials" do
    expected = [code_credentials(:sample_code_credential)]
    actual = clients(:sample_client).code_credentials.to_a
    assert_equal [], expected - actual
  end
end
