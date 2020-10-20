class Song < ApplicationRecord
  has_many :song_sources
  has_and_belongs_to_many :tags
  has_one :album
  has_one :user
end
