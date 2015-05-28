class CreateOrganizationSetting < ActiveRecord::Migration
  def change
    create_table :organization_settings do |t|
    	t.integer    :project_id
    	t.integer    :callflow_id
    	t.references :organization, index: true

      t.timestamps 
    end
  end
end
