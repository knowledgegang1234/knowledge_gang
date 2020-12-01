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
  get '/popular-tags' => 'tags#popular_tags', as: 'popular_tags'
  resources :categories
  devise_for :users, :controllers => { omniauth_callbacks: "users/omniauth_callbacks" }
  get '/:category_id/:id' => 'blogs#show', as: 'blog_show'
end