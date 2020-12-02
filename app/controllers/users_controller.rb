class UsersController < ApplicationController
  before_action :set_user, only: [:edit, :update, :show]

  def show
    @blogs = @user.blogs
    @top_tags = @user.top_tags
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

  private

  def user_params
    params.require(:user).permit(:id, :name, :bio, :birth_date, :country_id, :mobile_number)
  end

  def set_user
    @user = User.find_by(username: params[:id])
  end

end