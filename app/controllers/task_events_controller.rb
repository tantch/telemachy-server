class TaskEventsController < ApplicationController
  before_action :authenticate_user!

  def create
    @task_event = TaskEvent.new task_event_params
    @task_event.task_id = params[:task_id]
    @task_event.save
    render json: @task_event
  end
  def index
    @task_events = TaskEvent.where(task_id: params[:task_id]).all
    render :json => @task_events
  end

  private

    def task_event_params
      params.require(:task_event).permit(:time, :on_time)
    end

end
