Rails.application.routes.draw do
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
    end
  end
  get '/:category_id/:id' => 'blogs#show', as: 'blog_show'
end