class AccountsController < ApplicationController
  before_action :chech_admin_or_accountant_role!

  def index
    @accounts = Account.all
  end
end