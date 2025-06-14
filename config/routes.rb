Rails.application.routes.draw do
  get "/login" => "application#login"
  root "vault#index"
end
