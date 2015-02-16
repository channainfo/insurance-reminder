class AddFamilyCodeColumnToCalls < ActiveRecord::Migration
  def change
    add_column :calls, :family_code, :string
  end
end
