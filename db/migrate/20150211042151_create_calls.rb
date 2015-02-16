class CreateCalls < ActiveRecord::Migration
  def change
    create_table :calls do |t|
      t.references :client, index: true
      t.references :main, index: true
      t.string :status, default: Call::STATUS_PENDING
      t.date :expired_date
      t.string :phone_number
      t.datetime :update_status_at
      t.integer :calls_count, default: 0

      t.timestamps null: false
    end
  end
end
