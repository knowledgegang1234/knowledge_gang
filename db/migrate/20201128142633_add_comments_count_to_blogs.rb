class AddCommentsCountToBlogs < ActiveRecord::Migration[5.2]
  def change
    add_column :blogs, :comments_count, :integer, default: 0
    change_column :blogs, :likes_count, :integer, default: 0
  end
end
