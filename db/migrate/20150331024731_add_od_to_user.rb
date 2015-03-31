class AddOdToUser < ActiveRecord::Migration
  def change
    add_column :users, :ods, :text
  end
end
