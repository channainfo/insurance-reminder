class AddFullNameToCalls < ActiveRecord::Migration
  def change
    add_column :calls, :full_name, :string
  end
end
