class AddKindToClients < ActiveRecord::Migration
  def change
    add_column :clients, :kind, :integer, default: Client::KIND_AUTO
  end
end
