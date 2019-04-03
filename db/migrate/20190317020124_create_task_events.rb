class CreateTaskEvents < ActiveRecord::Migration[5.2]
  def change
    create_table :task_events do |t|
      t.references :task, foreign_key: true
      t.integer :time
      t.boolean :on_time

      t.timestamps
    end
  end
end
