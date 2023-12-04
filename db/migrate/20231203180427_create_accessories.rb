class CreateAccessories < ActiveRecord::Migration[7.1]
  def change
    create_table :accessories do |t|
      t.string :name
      t.references :bicycle, null: false, index: true

      t.timestamps
    end
  end
end
