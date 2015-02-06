class AddNumberOfRetryToClientTable < ActiveRecord::Migration
  def change
    add_column :clients, :number_retry, :integer, default: 0
  end
end
