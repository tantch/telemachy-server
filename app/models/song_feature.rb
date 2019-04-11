class SongFeature < ApplicationRecord
  belongs_to :song
  has_many :featured_artists
end
  
