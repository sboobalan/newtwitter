class AddDpToUsers < ActiveRecord::Migration[5.1]
  def change
	add_column :users, :dp, :string
  end
end
