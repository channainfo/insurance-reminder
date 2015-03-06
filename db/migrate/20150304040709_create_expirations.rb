class CreateExpirations < ActiveRecord::Migration
  def change
    create_table :expirations do |t|
      t.date :date
      t.text :clients

      t.timestamps null: false
    end

    add_index :expirations, :date
  end
end
