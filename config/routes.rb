Rails.application.routes.draw do
  mount RailsAdmin::Engine => '/admin', as: 'rails_admin'
  root to: 'blogs#index'
  resources :blogs
  resources :tags
  resources :categories
  devise_for :users, :controllers => { omniauth_callbacks: "users/omniauth_callbacks" }
end