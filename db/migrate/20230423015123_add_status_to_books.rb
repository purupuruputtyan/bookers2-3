class AddStatusToBooks < ActiveRecord::Migration[6.1]
  def change
    add_column :books, :status, :integur
  end
end
