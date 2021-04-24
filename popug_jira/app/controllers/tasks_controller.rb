# frozen_string_literal: true

class TasksController < ApplicationController
  before_action :chech_signed_in!
  before_action :chech_admin_role!

  def index
    @tasks = Task.all
    @tasks = @tasks.where(assignee_id: current_user.id) if params[:my]
    @task = Task.new
  end

  def create
    @task = Task.new(params[:task].permit(:name))
    @task.author_id = current_user.id
    if @task.save
      GenerateEvent.call('TaskCreated', 'tasks-stream', **@task.attributes)
      
      redirect_to tasks_path
    else
      render 'new'
    end
  end

  def assign_all
    users = GetAllUsers.call
    tasks = Task.incomplete
    
    tasks.each do |task|
      task.assign!(users.sample)
    end

    redirect_to tasks_path
  end

  def complete
    task = Task.find(params[:id])
    task.complete!

    redirect_to tasks_path
  end
end
