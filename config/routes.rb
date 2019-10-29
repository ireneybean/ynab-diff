Rails.application.routes.draw do
  get 'home/index'
  root to: 'home#index'

  get '/auth/:provider/callback', to: 'sessions#create'
  get '/login',                   to: 'sessions#new',     as: :login
  get '/auth/failure',            to: 'sessions#failure'
  get '/logout',                  to: 'sessions#destroy', as: :logout

  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
end