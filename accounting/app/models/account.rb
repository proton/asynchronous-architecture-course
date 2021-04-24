# frozen_string_literal: true

class Account < ApplicationRecord
  has_many :audit_logs, class_name: 'AccountAuditLog'
end
