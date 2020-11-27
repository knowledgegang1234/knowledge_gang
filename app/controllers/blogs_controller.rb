class BlogsController < ApplicationController

  before_action :set_category, only: [:show]

  def index
    @blogs = Blog.all
  end

  def new
    @blog = Blog.new
  end

  def create
    if @blog = current_user.blogs.create(blog_params.except(:tag_list))
      blog_params[:tag_list].gsub(' ', '').split(',').each do |tag_name|
        tag = Tag.find_or_create_by(name: tag_name)
        tagging = tag.taggings.new(blog_id: @blog.id)
        tagging.save
      end
      redirect_to @blog
    else
      render 'new'
    end
  end

  def show
    @blog = @category.blogs.friendly.find(params[:id])
  end

  def edit
    @blog = Blog.friendly.find(params[:id])
  end

  def update
    @blog = Blog.friendly.find(params[:id])
    if @blog.update_attributes(blog_params.except(:tag_list))
      blog_params[:tag_list].gsub(' ', '').split(',').each do |tag_name|
        tag = Tag.find_or_create_by(name: tag_name)
        tagging = tag.taggings.find_or_create_by(blog_id: @blog.id)
      end
      redirect_to @blog
    else
      render 'edit'
    end
  end

  private

  def set_category
    @category = Category.friendly.find(params[:category_id])
  end

  def blog_params
    params.require(:blog).permit(:id, :title, :description, :category_id, :tag_list)
  end
end
