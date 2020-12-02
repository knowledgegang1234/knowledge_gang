class AddUserToTagging < ActiveRecord::Migration[5.2]
  def change
    add_reference :taggings, :user, foreign_key: true
  end
end
