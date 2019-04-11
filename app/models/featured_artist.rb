class FeaturedArtist < ApplicationRecord
    belongs_to :song_feature
    has_many :artist_genres

  end
    