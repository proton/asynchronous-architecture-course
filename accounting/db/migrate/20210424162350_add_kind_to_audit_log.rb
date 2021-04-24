class AddKindToAuditLog < ActiveRecord::Migration[6.1]
  def change
    add_column :account_audit_logs, :kind, :string
  end
end
