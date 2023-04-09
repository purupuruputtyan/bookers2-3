class RenameBookIdColumnToBooks < ActiveRecord::Migration[6.1]
  def change
    rename_column :books, :book_id, :user_id
  end
end
