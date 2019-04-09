class CreateFeaturedArtists < ActiveRecord::Migration[5.2]
  def change
    create_table :featured_artists do |t|
      t.string :name
      t.string :artist_code
      t.references :track_feature, foreign_key: true
    end
  end
end
