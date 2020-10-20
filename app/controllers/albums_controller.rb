class AlbumsController < ApplicationController
  before_action :authenticate_user!

  def create
    @album = Album.new album_params

    @album.save
    render json: @album
  end

  def index

    @albums = Album.where(user_id: current_user.id).includes([:tags])
    render :json => @albums.to_json(:include => [:tags])
  end

  def update
    newAlbum =  params[:album]
    album = Album.find(params[:id])
    album.update(newAlbum)

    render status: 200

  end

  private

    def album
      params.require(:album).permit(:name,:color)
    end

end
