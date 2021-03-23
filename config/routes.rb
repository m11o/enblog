Rails.application.routes.draw do
  root to: 'articles#index'

  namespace :articles do
    resources :previews, only: %i[index show], param: :code
  end
  resources :articles
end
