class AddAvatarColumnsToUsers < ActiveRecord::Migration[5.2]
  def up
    remove_column :users, :avatar
    add_attachment :users, :avatar
  end

  def down
    remove_attachment :users, :avatar
  end
end
