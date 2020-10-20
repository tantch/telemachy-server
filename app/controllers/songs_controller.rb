class SongsController < ApplicationController
  before_action :authenticate_user!

  def create
    @song = Song.new song_params

    @song.save
    render json: @song
  end

  def index

    @songs = Song.where(user_id: current_user.id).includes([:tags])
    render :json => @songs.to_json(:include => [:tags])
  end

  def update
    newSong =  params[:song]
    song = Song.find(params[:id])
    song.update(newSong)

    render status: 200

  end

  private

    def song_params
      params.require(:song).permit(:album_id,:name,:color)
    end

end
