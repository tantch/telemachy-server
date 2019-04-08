class AddPlayedSongs < ActiveRecord::Migration[5.2]
  def change
    create_table :played_songs do |t|
      t.string :spotify_id
      t.string :artist
      t.string :name
      t.integer :popularity
      t.string :uri
      t.string :album_cover_64
      t.string :album_cover_640
      t.string :album_name
      t.timestamps
      t.references :track_feature, foreign_key: true
      t.belongs_to :user, index: true
    end
  end
end
