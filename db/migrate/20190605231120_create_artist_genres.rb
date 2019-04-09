class CreateArtistGenres < ActiveRecord::Migration[5.2]
  def change
    create_table :artist_genres do |t|
      t.string :name
      t.references :featured_artist, foreign_key: true
    end
  end
end
