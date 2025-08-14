class ReviewComments < ActiveRecord::Migration[8.0]
  def change
    create_table :review_comments do |t|
      t.references :user, null: false, foreign_key: true
      t.references :review, null: false, foreign_key: true

      t.timestamps
    end
  end
end
