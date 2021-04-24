class CreateAccountAuditLogs < ActiveRecord::Migration[6.1]
  def change
    create_table :account_audit_logs do |t|
      t.references :account
      t.integer :delta
      t.string :description

      t.timestamps
    end
  end
end
