class AddStatusInBlog < ActiveRecord::Migration[5.2]
  def change
    add_column :blogs, :status, :integer, index: :true
  end
end
