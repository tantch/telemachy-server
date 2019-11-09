class Song < ApplicationRecord
  has_many :library_songs
  has_many :played_songs
  has_one :song_feature

  def add_to_user_library(user)
    lsong = LibrarySong.find_or_create_by(song: self)
    lsong.user_id = user.id
    lsong.song = self
    lsong.save
  end
end
