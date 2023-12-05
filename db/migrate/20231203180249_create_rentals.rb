class CreateRentals < ActiveRecord::Migration[7.1]
  def change
    create_table :rentals do |t|
      t.references :bicycle, null: true, index: true
      t.references :renter, null: true, foreign_key: { to_table: :users }
      t.datetime :start_date
      t.datetime :end_date
      t.integer :rental_status
      t.decimal :total_cost

      t.timestamps
    end
  end
end
