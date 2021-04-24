require 'open-uri'

class GetAllUsers
  include Service

  def call
    begin
      url = ENV['AUTH_URL'] + "/users.json"
      a = JSON.load(URI.open(url))
    rescue
      a = []
    end
    a.map { |h| OpenStruct.new(h) }
  end
end