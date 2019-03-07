Rails.application.routes.draw do
  resources :search, controller: 'category_search', only: :create

  root 'category_search#index'
end
