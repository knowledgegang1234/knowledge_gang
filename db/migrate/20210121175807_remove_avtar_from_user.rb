class RemoveAvtarFromUser < ActiveRecord::Migration[5.2]
  def change
    remove_attachment :users, :avatar
    add_column :users, :avatar, :string
  end
end
