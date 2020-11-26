class AddBlogIdToLikes < ActiveRecord::Migration[5.2]
  def change
    add_reference :likes, :blog, null: false, foreign_key: true
  end
end
