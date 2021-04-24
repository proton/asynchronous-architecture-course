class AccountsController < ApplicationController
  before_action :chech_admin_or_accountant_role!

  def index
    today_logs = AccountAuditLog.where('created_at > ?', Date.today)
    @earned_by_management_today = -today_logs.where(kind: %w[TaskCompleted TaskAssigned]).sum(:delta)

    @accounts = Account.all
  end

  def log
    @account = Account.find(params[:id])
    @logs = @account.audit_logs
  end

  def my
    account = Account.find_by(user_id: current_user.id)
    render json: { balance: account.balance }
  end
end