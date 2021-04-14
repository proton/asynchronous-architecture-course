class AddAssigneeAndCompletedToTask < ActiveRecord::Migration[6.1]
  def change
    add_column :tasks, :assignee_id, :string
    add_column :tasks, :completed, :boolean, default: false
  end
end
