class CreateReviews < ActiveRecord::Migration[7.1]
  def change
    create_table :reviews do |t|
      t.references :rental, null: false, index: true
      t.references :reviewed_user, foreign_key: { to_table: :users }
      t.references :reviewer_user, foreign_key: { to_table: :users }
      t.integer :rating
      t.text :review_text
      t.datetime :review_date

      t.timestamps
    end
  end
end
