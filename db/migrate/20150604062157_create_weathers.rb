class CreateWeathers < ActiveRecord::Migration
  def change
    create_table :weathers do |t|
      t.json :data
      t.text :description
      t.float :temperature
      t.float :speed
      t.decimal :lat, precision: 10, scale: 6
      t.decimal :lon, precision: 10, scale: 6
      t.timestamps null: false
    end
  end
end
