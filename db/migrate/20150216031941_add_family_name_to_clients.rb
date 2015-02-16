class AddFamilyNameToClients < ActiveRecord::Migration
  def change
    add_column :clients, :family_name, :string
  end
end
