class AddLastTimeDoneToTasks < ActiveRecord::Migration[5.2]
  def change
    add_column :tasks, :last_time_done, :string
  end
end
