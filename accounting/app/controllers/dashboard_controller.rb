# frozen_string_literal: true

class DashboardController < ApplicationController
  before_action :chech_signed_in!
  before_action :chech_admin_or_accountant_role!

  def show
  end
end
