class CreateTasks < ActiveRecord::Migration[5.2]
  def change
    create_table :tasks do |t|
      t.references :user, foreign_key: true
      t.string :name
      t.string :category
      t.integer :frequency

      t.timestamps
    end
  end
end
