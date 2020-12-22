class UsersController < ApplicationController
  before_action :set_user, only: [:edit, :update, :show]
  before_action :authenticate_user!, only: [:bookmarked] 

  def show
    @blogs = @user.blogs.page(params[:page]).per(12)
    @top_tags = @user.top_tags
    @follow_action = current_user.following?(@user) ? 'unfollow' : 'follow'
    @followable_type = 'User'
    @followable_id = @user.id
  end

  def edit
    if @user == current_user

    end
  end

  def update
    if @user == current_user
      
    end
  end
  
  def bookmark
    if blog = Blog.find_by(slug: params[:id])
      @bookmark = current_user.bookmarks.find_or_initialize_by(blog: blog)
      @bookmark.active = !@bookmark.active?
      @bookmark.save
    else
      render file: 'public/404', status: :not_found, layout: true
    end
  end

  def bookmarked
    @blogs = Blog.includes(:category).where(id: current_user.bookmarks.pluck(:blog_id)).page(params[:page]).per(12)
  end

  private

  def user_params
    params.require(:user).permit(:id, :name, :bio, :birth_date, :country_id, :mobile_number)
  end

  def set_user
    @user = User.find_by(username: params[:id])
  end

end