# frozen_string_literal: true

class AccountAuditLog < ApplicationRecord
  belongs_to :account, inverse_of: :audit_logs

  after_create :update_balance!

  private

  def update_balance!
    account.increment!(:balance, delta)
  end
end
