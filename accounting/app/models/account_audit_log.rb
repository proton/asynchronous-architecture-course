# frozen_string_literal: true

class AccountAuditLog < ApplicationRecord
  belongs_to :account, inverse_of: :audit_logs
end
