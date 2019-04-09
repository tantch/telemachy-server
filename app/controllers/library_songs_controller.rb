class LibrarySongsController < ApplicationController
  before_action :authenticate_user!

  def index
    @songs = LibrarySong.where(user: current_user).includes([:tags,:song,:song_feature])
    render :json => @songs.to_json(:include => [:tags,:song,:song_feature])
  end

  def update
    newSong =  params[:library_song]
    song = LibrarySong.find(params[:id])
    if song.user != current_user
      render status: 401
      return
    end
    tags = newSong[:tags].map { |x| Tag.find_or_create_by(name: x) }
    song.tags = tags
    song.save

    render status: 200

  end

end
