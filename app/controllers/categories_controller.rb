class CategoriesController < ApplicationController

  def index
    @categories = Category.all
  end

  def show
    category = Category.friendly.find(params[:id])
    @blogs = category.blogs.page(params[:page]).per(12)
  end
end
