class AccountsController < ApplicationController
  before_action :chech_admin_or_accountant_role!

  def index
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