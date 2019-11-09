class AddSongToSongFeature < ActiveRecord::Migration[5.2]
  def change
    add_reference :song_features, :song, foreign_key: true
  end
end
