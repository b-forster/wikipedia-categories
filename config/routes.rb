Rails.application.routes.draw do
  resources :search, controller: 'category_search', only: :create
  # post 'search', to: 'category_search#search', as: 'search'

  root 'category_search#index'
end
