Rails.application.routes.draw do
  get 'user/page'
  get 'item/page'
  resources :listings
  devise_for :users
  root 'home#page'
end
