Rails.application.routes.draw do
  root to: 'articles#index'

  resources :articles
  namespace :articles do
    resources :previews, only: %i[index show]
  end
end
