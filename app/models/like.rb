class Like < ApplicationRecord
  belongs_to :user
  belongs_to :blog
  after_save :update_like_count

  private
  
  def update_like_count
    blog.update_column(:likes_count, blog.likes.sum(:hits))
  end
end