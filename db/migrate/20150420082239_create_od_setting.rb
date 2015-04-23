class CreateOdSetting < ActiveRecord::Migration
  def change
    create_table :od_settings do |t|
    	t.integer    :day_expired_get_record
    	t.integer    :day_expired_call
    	t.integer    :number_mark_as_failed
    	t.references :operational_district, index: true

      t.timestamps null: false
    end
  end
end
