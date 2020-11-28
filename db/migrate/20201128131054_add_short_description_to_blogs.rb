class AddShortDescriptionToBlogs < ActiveRecord::Migration[5.2]
  def change
    add_column :blogs, :short_description, :text
  end
end
