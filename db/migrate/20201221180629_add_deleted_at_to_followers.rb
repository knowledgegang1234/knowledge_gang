class AddDeletedAtToFollowers < ActiveRecord::Migration[5.2]
  def change
    add_column :followers, :deleted_at, :datetime
  end
end
