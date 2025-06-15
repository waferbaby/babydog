Rails.application.routes.draw do
  get "/login" => "application#login"
  get "/logout" => "application#logout"

  root "vault#index"
end
