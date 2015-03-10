class AddKindToCalls < ActiveRecord::Migration
  def change
    add_column :calls, :kind, :integer, default: Call::KIND_AUTO
  end
end
