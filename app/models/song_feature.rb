class SongFeature < ApplicationRecord
  has_many :featured_artists
  belongs_to :song
end
  
