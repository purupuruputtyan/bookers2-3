class AddStatusToUsers < ActiveRecord::Migration[6.1]
  def change
    add_column :users, :status, :integur, null: false, default: 0
  end
end
