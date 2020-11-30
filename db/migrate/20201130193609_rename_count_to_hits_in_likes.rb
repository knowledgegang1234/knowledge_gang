class RenameCountToHitsInLikes < ActiveRecord::Migration[5.2]
  def change
    rename_column :likes, :count, :hits
  end
end
