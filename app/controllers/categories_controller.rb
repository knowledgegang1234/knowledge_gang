class CategoriesController < ApplicationController

  def index
    @categories = Category.all
  end

  def show
    @category = Category.friendly.find(params[:id])
    @follow_action = current_user&.following?(@category) ? 'unfollow' : 'follow'
    @followable_type = 'Category'
    @followable_id = @category.id
    @blogs = @category.blogs.page(params[:page]).per(12)
    @blogs_count = @blogs.total_count
    @followers_count = @category.followers.count
  end
end
