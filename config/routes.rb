Rails.application.routes.draw do
  mount RailsAdmin::Engine => '/admin', as: 'rails_admin'
  root to: 'blogs#index'
  resources :blogs, except: [:show]
  resources :tags
  resources :categories
  get '/:category_id/:id' => 'blogs#show', as: 'blog_show'
  devise_for :users, :controllers => { omniauth_callbacks: "users/omniauth_callbacks" }
end