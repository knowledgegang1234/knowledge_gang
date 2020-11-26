Rails.application.routes.draw do
  root to: 'blogs#index'
  resources :blogs
  resources :tags
  devise_for :users, :controllers => { omniauth_callbacks: "users/omniauth_callbacks" }
end