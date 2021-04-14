# frozen_string_literal: true

class TasksController < ApplicationController
  before_action :chech_signed_in!
  before_action :chech_admin_role!

  def index
    @tasks = Task.all
    @task = Task.new
  end

  def create
    @task = Task.new(params[:task].permit(:name))
    @task.author_id = current_user.id
    if @task.save
      event = {
        event_id: SecureRandom.uuid,
        event_version: 1,
        event_time: Time.now.to_s,
        producer: 'popug_jira',
        event_name: 'TaskCreated',
        data: @task.attributes
      }
      WaterDrop::SyncProducer.call(event.to_json, topic: 'tasks-stream')

      redirect_to tasks_path
    else
      render 'new'
    end
  end

  def assign_all
    users = GetAllUsers.call
    tasks = Task.incomplete
    tasks.each do |task|
      # TODO: event
      task.assignee_id = users.sample.id
      task.save!
    end

    redirect_to tasks_path
  end
end
