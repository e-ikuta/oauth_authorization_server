Rails.application.routes.draw do
  get "authorize", to: "application#authorize"
  post "approve", to: "application#approve"
  post "token", to: "application#token"
end
