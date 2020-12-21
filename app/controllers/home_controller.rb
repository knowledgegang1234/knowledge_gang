class HomeController < ApplicationController

  def trending
    @trending_tags = Tagging.trending_tags
    @trending_users = User.includes(:blogs).first(6)
    @blogs = Blog.trending_blogs.page(params[:page]).per(12)
  end

end