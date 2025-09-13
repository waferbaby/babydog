Rails.application.routes.draw do
  root "application#index"

  get "/login/", to: "application#login", as: :login
  get "/logout/", to: "application#logout", as: :logout

  resources :rolls, only: [ :index, :show ]
end
