class Comment < ApplicationRecord

  belongs_to :user
  belongs_to :blog

  after_save :update_comment_count

  private
  
  def update_comment_count
    blog.update_column(:comments_count, blog.comments.count)
  end

end