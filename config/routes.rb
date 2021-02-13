Rails.application.routes.draw do
  require 'sidekiq/web'
  mount Sidekiq::Web => '/sidekiq'
  root to: 'blogs#index'
  resources :blogs, except: [:show] do
    member do
      post 'like'
      post 'bookmark' => 'users#bookmark'
    end
  end
  resources :comments
  resources :tags
  get 'tags-name-list' => 'tags#name_list'
  get '/trending' => 'home#trending', as: 'trending'
  get '/search' => 'home#search', as: 'search'
  resources :categories
  post '/follow_update' => 'followers#follow_update'
  devise_for :users, :controllers => {
    omniauth_callbacks: "users/omniauth_callbacks",
    sessions: "sessions",
    registrations: "registrations"
  }
  get '/bookmarked-articles' => 'users#bookmarked', as: 'bookmarked_articles'
  resources :users, only: [:show, :edit, :update] do
    member do
      put 'update_username'
      get 'comments'
      get 'following/suggestions' => 'users#following_suggestions', as: 'follow_suggestions'
      get 'following/categories' => 'users#following_categories', as: 'follow_categories'
      get 'following/people' => 'users#following_people', as: 'follow_people'
      get 'following/tags' => 'users#following_tags', as: 'follow_tags'
    end
  end
  get '/:category_id/:id' => 'blogs#show', as: 'blog_show'
  post '/image_upload' => 'attachments#image_upload'
end