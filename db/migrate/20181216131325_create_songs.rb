class CreateSongs < ActiveRecord::Migration[5.2]
  def change
    create_table :songs do |t|
      t.string :name
      t.string :code
      t.string :color

      t.timestamps
    end
  end
end
