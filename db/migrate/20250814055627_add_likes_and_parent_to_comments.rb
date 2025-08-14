class AddLikesAndParentToComments < ActiveRecord::Migration[8.0]
  def change
    add_column :comments, :likes, :integer, default: 0
    add_reference :comments, :parent, null: true, foreign_key: { to_table: :comments }
  end
end
