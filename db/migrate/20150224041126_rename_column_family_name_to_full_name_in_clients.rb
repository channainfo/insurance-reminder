class RenameColumnFamilyNameToFullNameInClients < ActiveRecord::Migration
  def change
    rename_column :clients, :family_name, :full_name
  end
end
