class RemoveUserAndReadFromBooks < ActiveRecord::Migration[8.0]
  def change
    remove_reference :books, :user, null: false, foreign_key: true
    remove_column :books, :read, :integer
  end
end
