Rails.application.routes.draw do
  root 'home#index'
  resources :prices
  resources :products

  post '/search', to: 'products#search'
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
end
