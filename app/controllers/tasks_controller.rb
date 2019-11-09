class TasksController < ApplicationController
  before_action :authenticate_user!

  def create
    @task = Task.new task_params
    puts params.inspect
    @task.user = current_user

    @task.save
    render json: @task
  end

  def index
    @tasks = Task.where(user: current_user).includes([:task_events])
    render :json => @tasks.to_json(:include => [:task_events])
  end

  def update
    newTask =  params[:task]
    task = Task.find(params[:id])
    if task.user != current_user
      render status: 401
      return
    end
    task.name = newTask["name"]
    task.last_time_done = newTask["last_time_done"]
    task.save

    render status: 200

  end

  private

    def task_params
      params.require(:task).permit(:name,:category,:frequency, :last_time_done)
    end

end
