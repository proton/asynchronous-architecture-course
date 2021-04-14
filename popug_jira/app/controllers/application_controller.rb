# frozen_string_literal: true

class ApplicationController < ActionController::Base
  before_action :load_auth_info
  helper_method :current_user

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

  def current_user
    return nil unless user_authorised?
    OpenStruct.new(@auth_payload)
  end

  def chech_signed_in!
    return if user_authorised?
    redirect_to "#{sign_in_url}?redirect_to=#{full_url_for}"
  end

  def sign_in_url
    ENV['AUTH_URL'] + '/sign_in'
  end

  def chech_admin_role!
    return true if current_user.role == 'admin'
    render_403_forbidden
  end

  def render_403_forbidden
    render status: :forbidden, html: 'Forbidden'
  end
end
