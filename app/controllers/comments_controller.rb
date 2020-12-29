class CommentsController < ApplicationController
  before_action :authenticate_user!

  def create
    if blog = Blog.find_by(slug: params[:blog_id])
      @comment = blog.comments.new(comments_params)
      @comment.user = current_user
      unless @comment.save
        @errors = @comment.errors.full_messages
      end
      respond_to do |format|
        format.js
      end
    else
      render file: 'public/404', status: :not_found, layout: true
    end
  end

  private

  def comments_params
    params.require(:comment).permit(:id, :body)
  end

end