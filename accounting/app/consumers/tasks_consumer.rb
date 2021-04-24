# require '../../models/account.rb'

class TasksConsumer < ApplicationConsumer
  def consume
    params_batch.each do |message|
      puts '-' * 80
      p message
      puts '-' * 80

      data = message.payload['data']

      case  message.payload['event_name']
      when 'TaskCreated'
        # do nothing
      when 'TaskAssigned'
        cost = data['cost']
        user_id = data['assignee_id']
        task_name = data['task_name']
        task_id = data['task_id']

        account = Account.find_or_create_by(user_id: user_id)
        description = "task '#{task_name}' (#{task_id}) assigned"
        account.audit_logs.create!(delta: cost, description: description, kind: 'TaskAssigned')
      when 'TaskCompleted'
        cost = data['cost']
        user_id = data['assignee_id']
        task_name = data['task_name']
        task_id = data['task_id']

        account = Account.find_or_create_by(user_id: user_id)
        description = "task '#{task_name}' (#{task_id}) completed"
        account.audit_logs.create!(delta: cost, description: description, kind: 'TaskCompleted')
      end
    end
  end
end