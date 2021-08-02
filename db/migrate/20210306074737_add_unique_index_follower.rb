class AddUniqueIndexFollower < ActiveRecord::Migration[5.2]
  def change
    Follower.unscoped.delete_all
    add_index :followers, [:user_id, :followable_type, :followable_id], unique: true, name: 'unique_follower_thing'
  end
end
