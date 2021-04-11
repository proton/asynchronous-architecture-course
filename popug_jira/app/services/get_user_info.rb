require 'open-uri'

class GetUserInfo
  include Service

  attr_reader :user_id
  
  def initialize(user_id)
    @user_id = user_id
  end

  def call
    url = ENV['AUTH_URL'] + "/users/#{user_id}.json"
    h = JSON.load(URI.open(url))
    OpenStruct.new(h)
  rescue
    OpenStruct.new
  end
end