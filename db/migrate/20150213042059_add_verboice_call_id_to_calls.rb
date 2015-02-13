class AddVerboiceCallIdToCalls < ActiveRecord::Migration
  def change
    add_column :calls, :verboice_call_id, :integer
  end
end
