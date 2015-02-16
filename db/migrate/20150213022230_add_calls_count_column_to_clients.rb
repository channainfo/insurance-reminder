class AddCallsCountColumnToClients < ActiveRecord::Migration
  def change
    add_column :clients, :calls_count, :integer, default: 0
  end
end
