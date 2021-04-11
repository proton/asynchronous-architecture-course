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
    if @task.save
      redirect_to tasks_path
    else
      render 'new'
    end
  end
end
