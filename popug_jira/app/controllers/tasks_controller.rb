# frozen_string_literal: true

class TasksController < ApplicationController
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

  private

  def chech_admin_role!
    return true if user_role == 'admin'
    return render_403_forbidden if user_authorised?
    redirect_to ENV['SIGN_IN_URL']
  end

  def render_403_forbidden
    render status: :forbidden, html: 'Forbidden'
  end
end
