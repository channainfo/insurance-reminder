class CreateOperationalDistricts < ActiveRecord::Migration
  def change
    create_table :operational_districts do |t|
      t.string :name
      t.string :code
      t.integer :external_id
      t.boolean :enable_reminder

      t.timestamps null: false
    end
  end
end
