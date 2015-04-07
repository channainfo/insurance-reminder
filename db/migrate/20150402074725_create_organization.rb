class CreateOrganization < ActiveRecord::Migration
  def change
    create_table :organizations do |t|
    	t.string :name
    	t.text   :ods

      t.timestamps null: false
    end
  end
end
