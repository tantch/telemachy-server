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
end
