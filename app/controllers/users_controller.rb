class UsersController < ApplicationController
  before_action :set_user, only: [:edit, :update, :show, :update_username, :comments]
  before_action :authenticate_user!, only: [:bookmarked, :edit, :update,:bookmark, :update_username]
  before_action :authenticate_access, only: [:edit, :update, :update_username]

  def show
    blog_status = params[:status] == 'draft' ? 0 : 1
    @blogs = Blog.unscoped.where(user: @user, status: blog_status).page(params[:page]).per(12)
    @top_tags = @user.top_tags
    @follow_action = current_user&.following?(@user) ? 'unfollow' : 'follow'
    @followable_type = 'User'
    @followable_id = @user.id
  end

  def comments
    @comments = @user.comments.order(id: :desc)
    @top_tags = @user.top_tags
    @follow_action = current_user&.following?(@user) ? 'unfollow' : 'follow'
    @followable_type = 'User'
    @followable_id = @user.id
  end

  def edit
  end

  def update
    if @user.update_attributes(user_params)
      redirect_to user_path(@user.username)
    else
      render 'edit'
    end
  end

  def update_username
    if @user.update_attributes(user_params)
      redirect_to edit_user_path(@user.username)
    else
      @error = @user.errors.full_messages.first
      respond_to do |format|
        format.js
      end
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
    @blogs = Blog.includes(:category).where(id: current_user.bookmarks.active.pluck(:blog_id)).page(params[:page]).per(12)
  end

  private

  def user_params
    params.require(:user).permit(:id, :name, :bio, :birth_date, :country_id, :mobile_number, :username)
  end

  def set_user
    unless @user = User.find_by(username: params[:id])
      render file: 'public/404', status: :not_found, layout: true
    end
  end

  def authenticate_access
    render :file => 'public/404', status: 401 unless @user == current_user
  end

end