class PlayedSong < ApplicationRecord
    belongs_to :user
    has_one :track_feature
  end
  