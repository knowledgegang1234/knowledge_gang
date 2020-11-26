class AddCategoryIdToBlogs < ActiveRecord::Migration[5.2]
  def change
    add_reference :blogs, :category, null: false, foreign_key: true
  end
end
