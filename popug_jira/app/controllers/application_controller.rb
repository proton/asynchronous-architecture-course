# frozen_string_literal: true

class ApplicationController < ActionController::Base
  before_action :load_auth_info

  private

  def load_auth_info
    auth_token = cookies[:auth_token]
    return if auth_token.blank?
    @auth_payload, _ = JWT.decode auth_token, nil, false
  end

  def user_authorised?
    @auth_payload.present?
  end

  def user_not_authorised?
    !user_authorised?
  end

  def user_role
    return nil unless user_authorised?
    @auth_payload['role']
  end

  def chech_signed_in!
    return if user_authorised?
    redirect_to "#{ENV['SIGN_IN_URL']}?redirect_to=#{full_url_for}"
  end

  def chech_admin_role!
    return true if user_role == 'admin'
    render_403_forbidden
  end

  def render_403_forbidden
    render status: :forbidden, html: 'Forbidden'
  end
end
