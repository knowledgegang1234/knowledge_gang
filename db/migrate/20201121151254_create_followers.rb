class CreateFollowers < ActiveRecord::Migration[5.2]
  def change
    create_table :followers do |t|
      t.references :user, null: false, foreign_key: true, index: true
      t.references :followable, polymorphic: true, index: true
      t.timestamps
    end
  end
end
