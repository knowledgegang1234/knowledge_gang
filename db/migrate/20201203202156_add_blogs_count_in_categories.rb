class AddBlogsCountInCategories < ActiveRecord::Migration[5.2]
  def change
    add_column :categories, :blogs_count, :integer, default: 0
  end
end
