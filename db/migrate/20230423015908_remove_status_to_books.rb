class RemoveStatusToBooks < ActiveRecord::Migration[6.1]
  def change
    remove_column :books, :status, :integur
  end
end
