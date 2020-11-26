class TagsController < ApplicationController

  def show
    tag = Tag.friendly.find(params[:id])
    blog_ids = tag.taggings.pluck(:blog_id)
    @blogs = Blog.where(id: blog_ids)
  end

end