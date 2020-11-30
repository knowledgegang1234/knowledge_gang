class AddDefaultToLikeHits < ActiveRecord::Migration[5.2]
  def change
    change_column :likes, :hits, :integer, default: 0
  end
end
