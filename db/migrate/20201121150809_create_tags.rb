class CreateTags < ActiveRecord::Migration[5.2]
  def change
    create_table :tags do |t|
      t.string :name
      t.boolean :popular, default: false
      t.timestamps
    end
  end
end
