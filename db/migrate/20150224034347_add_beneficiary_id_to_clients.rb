class AddBeneficiaryIdToClients < ActiveRecord::Migration
  def change
    add_column :clients, :beneficiary_id, :integer
  end
end
