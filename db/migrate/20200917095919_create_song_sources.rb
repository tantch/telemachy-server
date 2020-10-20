class CreateSongSources < ActiveRecord::Migration[5.2]
  def change
    create_table :song_sources do |t|
      t.references :song, foreign_key: true
      t.string :source
      t.string :code
    end
  end
end
