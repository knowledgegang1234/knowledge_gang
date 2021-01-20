class BlogsController < ApplicationController

  # before_action :set_category, only: [:show]
  before_action :set_blog, only: [:like, :bookmark]
  before_action :set_unscoped_blog, only: [:edit, :update]
  before_action :authenticate_user!, only: [:new, :edit, :create, :update, :like]
  before_action :authorize_user, only: [:edit, :update]

  def index
    @blogs = Blog.order(id: :desc).page(params[:page]).per(12)
    @home_tags = Tagging.home_tags(4)
    @trending_categories = Category.select('id,name,blogs_count,slug').order(blogs_count: :desc).limit(4)
  end

  def new
    @blog = Blog.new
  end

  def create
    @blog = current_user.blogs.new(blog_params.except(:tag_list,:draft))
    @blog.status = blog_params[:draft] ? 0 : 1
    if @blog.save
      blog_params[:tag_list].gsub(' ', '').split(',').each do |tag_name|
        tag = Tag.find_or_create_by(name: tag_name)
        tagging = tag.taggings.new(blog_id: @blog.id, user_id: current_user.id)
        tagging.save
      end
      redirect_to @blog.draft? ? user_path(current_user.username) : @blog
    else
      render 'new'
    end
  end

  def show
    category = Category.find_by(slug: params[:category_id])
    if category
      @blog = category.blogs.find_by(slug: params[:id])
      if @blog.blank?
        render :file => 'public/404', :status => :not_found, :layout => true
      end
    else
      set_blog
      redirect_to blog_show_path(id: @blog, category_id: @blog.category) if @blog
    end
    @comments = @blog.comments.order(id: :desc) if @blog
  end

  def edit
  end

  def update
    if @blog.update_attributes(blog_params.except(:tag_list))
      blog_params[:tag_list].gsub(' ', '').split(',').each do |tag_name|
        tag = Tag.find_or_create_by(name: tag_name)
        tagging = tag.taggings.find_or_create_by(blog_id: @blog.id, user_id: current_user.id)
      end
      redirect_to @blog.draft? ? user_path(current_user.username) : @blog
    else
      render 'edit'
    end
  end

  def like
    like = @blog.likes.find_or_initialize_by(user_id: current_user.id)
    like.hits += 1
    unless like.save
      @errors = like.errors.full_messages
    end
    respond_to do |format|
      format.js
    end
  end

  private

  def set_blog
    unless @blog = Blog.find_by(slug: params[:id])
      render :file => 'public/404', :status => :not_found, :layout => true
    end
  end

  def set_unscoped_blog
    unless @blog = Blog.unscoped.find_by(slug: params[:id])
      render :file => 'public/404', :status => :not_found, :layout => true
    end
  end

  def blog_params
    params.require(:blog).permit(:id, :title, :description, :category_id, :tag_list, :draft)
  end

  def authorize_user
    unless @blog.user == current_user
      render :file => 'public/404', :status => :not_found, :layout => true
    end
  end
end
