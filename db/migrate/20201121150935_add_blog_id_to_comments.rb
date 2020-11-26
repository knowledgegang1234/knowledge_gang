class AddBlogIdToComments < ActiveRecord::Migration[5.2]
  def change
    add_reference :comments, :blog, null: false, foreign_key: true
  end
end
