Rails.application.routes.draw do
  root "password#index"
  post 'password', to: 'password#create'

  get 'password', to: 'password#index'
end
