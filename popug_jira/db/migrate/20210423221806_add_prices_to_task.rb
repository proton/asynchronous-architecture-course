class AddPricesToTask < ActiveRecord::Migration[6.1]
  def change
    add_column :tasks, :assign_cost, :integer
    add_column :tasks, :complete_cost, :integer
  end
end
