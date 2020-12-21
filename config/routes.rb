Rails.application.routes.draw do
  mount RailsAdmin::Engine => '/admin', as: 'rails_admin'
  root to: 'blogs#index'
  resources :blogs, except: [:show] do
    member do
      post 'like'
      post 'bookmark' => 'users#bookmark'
    end
  end
  resources :comments
  resources :tags
  get '/trending' => 'home#trending', as: 'trending'
  resources :categories
  post '/follow_update' => 'followers#follow_update'
  devise_for :users, :controllers => { omniauth_callbacks: "users/omniauth_callbacks" }
  resources :users, only: [:show, :edit, :update]
  get '/:category_id/:id' => 'blogs#show', as: 'blog_show'
end