Rails.application.routes.draw do
  root "home#index"

  get '/login/', to: 'application#login', as: :login
  get '/logout/', to: 'application#logout', as: :logout

  get '/vault/', to: 'vault#index'
end
