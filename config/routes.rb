Rails.application.routes.draw do
  root "home#index"

  get '/login/', to: 'home#login', as: :login
  get '/vault/', to: 'vault#index'
end
