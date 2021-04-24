class SetAccountDefault < ActiveRecord::Migration[6.1]
  def change
    change_column :accounts, :balance, :integer, default: 0
  end
end
