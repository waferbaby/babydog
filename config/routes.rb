Rails.application.routes.draw do
  resources :vault

  get "/login" => "application#login"
  get "/logout" => "application#logout"

  root "home#index"
end
