class RenameColumnExpiredDateToExpirationDateInCalls < ActiveRecord::Migration
  def change
    rename_column :calls, :expired_date ,:expiration_date
  end
end
