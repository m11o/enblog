Rails.application.routes.draw do
  root to: 'articles#index'

  namespace :articles do
    resources :previews, only: %i[index show], param: :code
    resources :publications, only: %i[create]
    resources :bulk_creations, only: :create
  end
  resources :articles
end
