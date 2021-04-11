class AddAuthorToTask < ActiveRecord::Migration[6.1]
  def change
    add_column :tasks, :author_id, :string
  end
end
