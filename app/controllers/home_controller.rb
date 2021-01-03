class HomeController < ApplicationController

  def trending
    @trending_tags = Tagging.trending_tags_with_count
    @trending_users = User.includes(:blogs).first(5)
    @blogs = Blog.trending_blogs.page(params[:page]).per(12)
  end

end