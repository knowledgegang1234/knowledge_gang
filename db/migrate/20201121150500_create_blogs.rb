class CreateBlogs < ActiveRecord::Migration[5.2]
  def change
    create_table :blogs do |t|
      t.string :title
      t.text :description
      t.integer :likes_count
      t.timestamps
    end
  end
end
