if Client.count.zero?
  client = Client.create!(
    client_id: ENV.fetch("CLIENT_ID"),
    client_secret: ENV.fetch("CLIENT_SECRET"),
  )
end

if RedirectUri.count.zero?
  client.redirect_uris.create!(
    client: client,
    uri: ENV.fetch("REDIRECT_URL"),
  )
end

if Scope.count.zero?
  client.scopes.create!([
    { name: "foo" },
    { name: "bar" },
  ])
end
