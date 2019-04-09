class LibrarySong < ApplicationRecord
  belongs_to :user
  belongs_to :song
  has_and_belongs_to_many :tags
end
