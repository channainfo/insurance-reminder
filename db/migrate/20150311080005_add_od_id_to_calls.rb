class AddOdIdToCalls < ActiveRecord::Migration
  def change
    add_column :calls, :od_id, :integer
  end
end
