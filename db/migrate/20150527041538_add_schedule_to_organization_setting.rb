class AddScheduleToOrganizationSetting < ActiveRecord::Migration
  def change
  	add_column :organization_settings, :schedule_id, :integer
  end
end
