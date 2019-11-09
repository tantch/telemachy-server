class ChangeTimeToTimestampInTask < ActiveRecord::Migration[5.2]
  def change
    change_column :task_events, :time, :string    
  end
end
