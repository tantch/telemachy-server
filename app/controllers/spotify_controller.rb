require "uri"
require "net/http"
require "net/https"

class SpotifyController < ApplicationController

  def index
    puts "init spotify controller"
    user = User.find_by_email(params[:state])
    
              
    body = {
      :grant_type => "authorization_code",
      :code => params[:code],
      :redirect_uri => ENV["SERVER_URL"] + "/spotify",
      :client_id => ENV["SPOTIFY_CLIENT_ID"],
      :client_secret => ENV["SPOTIFY_CLIENT_SECRET"]
    }
    uri = URI.parse('https://accounts.spotify.com/api/token');
    http = Net::HTTP.new(uri.host,uri.port)
    http.use_ssl = true
    request = Net::HTTP::Post.new(uri.path)
    request.set_form_data(body)
    response = http.request(request)
    puts response
    data = JSON.parse(response.body)
    puts "data"
    puts data
    user.spotify_token = data["access_token"]
    user.spotify_refresh_token = data["refresh_token"]
    user.save
    redirect_to ENV["CLIENT_URL"]
  end

  def play
    puts "init spotify play"
    codes = params[:musicCode].map{ |c| "spotify:track:" + c}
    puts codes
    body = {
      uris: codes
    }.to_json
    uri = URI.parse("https://api.spotify.com/v1/me/player/play")
    http = Net::HTTP.new(uri.host,uri.port)
    http.use_ssl = true
    request = Net::HTTP::Put.new(uri.path)
    request.body = body;
    request.add_field("Authorization", "Bearer " + current_user.spotify_token)
    response = http.request(request)
    puts response
    render status: 200
  end


  def spotify_me

    uri = URI.parse("https://api.spotify.com/v1/me/")
    http = Net::HTTP.new(uri.host,uri.port)
    http.use_ssl = true
    request = Net::HTTP::Get.new(uri.path)
    request.add_field("Authorization", "Bearer " + current_user.spotify_token)
    response = http.request(request)
    return JSON.parse(response.body)

  end

  def fetchSavedSongFeatures(codes)
    puts 'fetching saved song features from Spotify'
    tracksFeatures = Array.new
    codes.each do |spotifyId|
      spotifyId.slice!("spotify:track:")
      trackFeature=fetchTrackFeatures(spotifyId,true)
      if(!trackFeature)    
        break
      end
      tracksFeatures << trackFeature
    end
    return tracksFeatures
  end

  def add_songs_to_playlist(playlist_id, codes)

    puts "add songs to spotify playlist"
    body = {
      uris: codes
    }.to_json
    puts body.inspect
    uri = URI.parse("https://api.spotify.com/v1/playlists/" + playlist_id + "/tracks")
    http = Net::HTTP.new(uri.host,uri.port)
    http.use_ssl = true
    request = Net::HTTP::Post.new(uri.path)
    puts 'putting songs to spotify playlist'
    request.body = body;
    puts body
    request.add_field("Authorization", "Bearer " + current_user.spotify_token)
    response = http.request(request)
    puts response.inspect
    puts response.body
  end

  def create_playlist


    puts "init create spotify playlist"
    spotify_user = spotify_me
    codes = params[:musicCode].map{ |c| "spotify:track:" + c}


    body = {
      name: "autogeneratedplaylist-" + (0...8).map { (65 + rand(26)).chr }.join,

    }.to_json
    uri = URI.parse("https://api.spotify.com/v1/users/" + spotify_user["id"] + "/playlists")
    http = Net::HTTP.new(uri.host,uri.port)
    http.use_ssl = true
    request = Net::HTTP::Post.new(uri.path)
    request.body = body;
    request.add_field("Authorization", "Bearer " + current_user.spotify_token)
    response = http.request(request)
    playlist= JSON.parse(response.body)

    add_songs_to_playlist(playlist["id"],codes);

    render json: playlist
  end

  def create_dancing_playlist


    puts "init create spotify playlist"
    spotify_user = spotify_me
    codes = params[:musicCode].map{ |c| "spotify:track:" + c}
    puts codes

    body = {
      name: "autogenerated-lowenergy-" + (0...8).map { (65 + rand(26)).chr }.join,

    }.to_json
    uri = URI.parse("https://api.spotify.com/v1/users/" + spotify_user["id"] + "/playlists")
    http = Net::HTTP.new(uri.host,uri.port)
    http.use_ssl = true
    request = Net::HTTP::Post.new(uri.path)
    request.body = body;
    request.add_field("Authorization", "Bearer " + current_user.spotify_token)
    response = http.request(request)
    playlist= JSON.parse(response.body)
    trackFeatures=fetchSavedSongFeatures(codes)
    dancingCodes=trackFeatures.select{|t| t[:energy] < 0.4}
    add_songs_to_playlist(playlist["id"],dancingCodes.collect(&:uri));
    render json: playlist
  end

  def load
      uri = URI.parse("https://api.spotify.com/v1/me/tracks")
      begin
        puts uri
        http = Net::HTTP.new(uri.host,uri.port)
        http.use_ssl = true
        request = Net::HTTP::Get.new(uri.request_uri)
        puts "token"
        puts current_user.spotify_token
        request.add_field("Authorization", "Bearer " + current_user.spotify_token)
        puts "before response"
        response = http.request(request)
        puts response
        data = JSON.parse(response.body)
        data["items"].each do |i|
          song = Song.find_or_create_by({code: i["track"]["id"]})
          song.user= current_user
          song.name = i["track"]["name"]
          song.artist = i["track"]["album"]["artists"][0]["name"]
          song.source = "spotify"
          song.save
        end
        uri = data["next"] ? URI.parse(data["next"]) : ""
        puts data["items"].length
      end while data["next"]
  end

  def fetchCurrentlyPlaying
    uri = URI.parse("https://api.spotify.com/v1/me/player")
    begin
      puts uri
      http = Net::HTTP.new(uri.host,uri.port)
      http.use_ssl = true
      request = Net::HTTP::Get.new(uri.request_uri)
      vaniauser=User.find_by(email:'vanialeite94@gmail.com')
      puts "token"
      puts vaniauser.spotify_token
      request.add_field("Authorization", "Bearer " + vaniauser.spotify_token)
      begin
        puts "before response"
        response = http.request(request)
      rescue Exception => e
        puts "An error of type #{ex.class} happened, message is #{ex.message}"
      end
      if response.body.present?
        data = JSON.parse(response.body)
        puts response.body
        if data["is_playing"]==true 
          track= data["item"]
            playedSong = PlayedSong.new
            playedSong.user_id=vaniauser.id
            playedSong.spotify_id=track["id"]
            playedSong.artist=""
            track["artists"].each do |i|
              playedSong.artist.concat(i["name"]).concat(",")
            end
            playedSong.name=track["name"]
            playedSong.popularity=track["popularity"]
            playedSong.uri=track["uri"]
            playedSong.album_cover_640=track["album"]["images"][0]["url"]
            playedSong.album_name=track["album"]["name"]
            trackFeature=fetchTrackFeatures(playedSong.spotify_id,false)
            playedSong.track_feature_id=trackFeature.id
            playedSong.save
            
            render json: {song: {currentlyPlaying: playedSong, songFeatures: trackFeature}} and return
        else
          render status: 204, json: {
            message: "The user is in pause mode right now.",
          }.to_json and return
          end
        end
      else
        render status: 204, json: {
          message: "The user is not currenly listening to any music.",
        }.to_json and return
      end
  end

  def fetchTrackFeatures (spotifyId,isSaved)
    uri = URI.parse("https://api.spotify.com/v1/audio-features/#{spotifyId}")
    begin
      if(TrackFeature.exists?(spotify_id: spotifyId))
        return TrackFeature.find_by({spotify_id: spotifyId})
      end
      puts uri
      response=sendRequest(uri)
      if response.body.present?
        track = JSON.parse(response.body)
        track["error"].nil?
            trackInfo=fetchTrack(track["id"])
            trackFeature = TrackFeature.find_or_create_by(spotify_id: track["id"])
            trackFeature.spotify_id=track["id"]
            trackFeature.uri=track["uri"]
            trackFeature.track_href=track["track_href"]
            trackFeature.analysis_url=track["analysis_url"]
            trackFeature.time_signature=track["time_signature"]
            trackFeature.acousticness=track["acousticness"]
            trackFeature.danceability=track["danceability"]
            trackFeature.energy=track["energy"]
            trackFeature.instrumentalness=track["instrumentalness"]
            trackFeature.liveness=track["liveness"]
            trackFeature.loudness=track["loudness"]
            trackFeature.speechiness=track["speechiness"]
            trackFeature.speechiness=track["speechiness"]
            trackFeature.valence=track["valence"]
            trackFeature.tempo=track["tempo"]
            trackFeature.isSaved=isSaved
            trackFeature.release_date=trackInfo["album"]["release_date"]
            trackFeature.popularity=trackInfo["popularity"]
            trackFeature.save
            saveTrackArtistsAndGenres(trackInfo,trackFeature.id)
            return TrackFeature
            .Joins(:feautured_artists).where(feautured_artists: {artist.track_feature_id:spotifyId})
            .Joins(:artist_genres).where(artist_genres: {artist_genre.featured_artist_id:artist.artist_code})

             TrackFeature.includes()
        end
      end
    end
  end

  def sendRequest(uri)
    puts uri
    http = Net::HTTP.new(uri.host,uri.port)
    http.use_ssl = true
    request = Net::HTTP::Get.new(uri.request_uri)
    puts "token"
    puts User.first.spotify_token
    request.add_field("Authorization", "Bearer " + User.first.spotify_token)
    begin
      puts "before response"
      response = http.request(request)
    rescue Exception => e
      puts "An error of type #{e.class} happened, message is #{e.message}"
    end
    return response
  end
    

  def fetchTrack(spotify_id)
    uri = URI.parse("https://api.spotify.com/v1/tracks/#{spotify_id}")
    response=sendRequest(uri)
    if response.body.present?
      track = JSON.parse(response.body)
      return track
    end
  end

  def saveTrackArtistsAndGenres(track,feature_song_id)
    track["artists"].each do |artist|
      uri = URI.parse("https://api.spotify.com/v1/artists/#{artist["id"]}")
      response=sendRequest(uri)
      puts artist
      if response.body.present?
        artist = JSON.parse(response.body)
        featuredArtist=FeaturedArtist.new
        featuredArtist.name=artist["name"]
        featuredArtist.artist_code=artist["id"]
        featuredArtist.track_feature_id=feature_song_id
        featuredArtist.save
        artist["genres"].each do |genre|
          artistGenre = ArtistGenre.new
          artistGenre.name=genre
          artistGenre.featured_artist_id=featuredArtist.id
          artistGenre.save
        end
      end
    end
  end
  


