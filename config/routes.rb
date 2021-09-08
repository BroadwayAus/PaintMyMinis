Rails.application.routes.draw do
  devise_for :usernames
  get 'user/page'
  get 'item/page'
  resources :listings
  devise_for :users
  root 'home#page'
  post '/payments/webhook', to: "payments#webhook", as: "webhook"
end
