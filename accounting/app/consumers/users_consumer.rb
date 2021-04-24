# require '../../models/account.rb'

class UsersConsumer < ApplicationConsumer
  def consume
    params_batch.each do |message|
      puts '-' * 80
      p message
      puts '-' * 80

      case  message.payload['event_name']
      when 'UserCreated'
        user_id = message.payload['data']['_id']
        ::Account.create!(user_id: user_id)
      end
    end
  end
end