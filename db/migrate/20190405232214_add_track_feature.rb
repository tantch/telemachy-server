class AddTrackFeature < ActiveRecord::Migration[5.2]
  def change
    create_table :track_features do |t|
      t.string :spotify_id
      t.string :uri
      t.integer :time_signature
      t.float :acousticness
      t.float :danceability
      t.float :energy
      t.float :instrumentalness
      t.float :liveness
      t.float :loudness
      t.float :speechiness
      t.float :valence
      t.float :tempo
      t.string :track_href
      t.string :analysis_url
      t.integer :popularity
      t.datetime :release_date
      t.timestamps
    end
  end
end
