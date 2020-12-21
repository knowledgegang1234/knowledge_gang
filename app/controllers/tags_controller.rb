class TagsController < ApplicationController

  def popular_tags
    
  end

  def show
    @tag = Tag.friendly.find(params[:id])
    @follow_action = current_user.following?(@tag) ? 'unfollow' : 'follow'
    @followable_type = 'Tag'
    @followable_id = @tag.id
    @blogs_count = @tag.taggings.count
    @followers_count = @tag.followers.count
    blog_ids = @tag.taggings.pluck(:blog_id)
    @blogs = Blog.where(id: blog_ids).page(params[:page]).per(12)
  end

end