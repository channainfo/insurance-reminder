class CreateClients < ActiveRecord::Migration
  def change
    create_table :clients do |t|
      t.string :phone_number
      t.string :family_code
      t.date :expiration_date

      t.timestamps null: false
    end
  end
end
