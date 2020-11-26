class AddUsernameToUsers < ActiveRecord::Migration[5.2]
  def change
    add_column :users, :username, :string
    add_column :users, :bio, :text
    add_column :users, :birth_date, :date
    add_column :users, :mobile_number, :string
    add_column :users, :role, :integer
  end
end
