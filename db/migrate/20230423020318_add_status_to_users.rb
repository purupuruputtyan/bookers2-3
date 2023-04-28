class AddStatusToUsers < ActiveRecord::Migration[6.1]
  def change
    add_column :users, :status, :boolean, null: false, default: true
  end
end
