require 'open-uri'

class GetUserInfo
  include Service

  attr_reader :user_id
  
  def initialize(user_id)
    @user_id = user_id
  end

  def call
    begin
      url = ENV['AUTH_URL'] + "/users/#{user_id}.json"
      h = JSON.load(URI.open(url))
    rescue
      h = { id: user_id, login: user_id }
    end
    
    OpenStruct.new(h)
  end
end