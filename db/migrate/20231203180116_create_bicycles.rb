class CreateBicycles < ActiveRecord::Migration[7.1]
  def change
    create_table :bicycles do |t|
      t.references :owner, null: false, foreign_key: { to_table: :users }
      t.string :model
      t.integer :bicycle_type
      t.integer :size
      t.string :condition
      t.integer :price_per_hour
      t.float :latitude
      t.float :longitude
      t.string :address
      t.text :description

      t.timestamps
    end
  end
end
