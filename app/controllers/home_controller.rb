class HomeController < ApplicationController

  def trending
    @trending_tags = Tagging.trending_tags
    @trending_users = User.first(6)
    @blogs = Blog.trending_blogs
  end

end