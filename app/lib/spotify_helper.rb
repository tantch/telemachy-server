require "base64"

class SpotifyHelper

  def self.refresh_spotify_token(user)
    
    body = {
      grant_type: "refresh_token",
      refresh_token: user.spotify_refresh_token,
      :client_id => ENV["SPOTIFY_CLIENT_ID"],
      :client_secret => ENV["SPOTIFY_CLIENT_SECRET"]
    }
    uri = URI.parse("https://accounts.spotify.com/api/token")
    http = Net::HTTP.new(uri.host,uri.port)
    http.use_ssl = true
    
    http.set_debug_output($stdout)

    request = Net::HTTP::Post.new(uri.path)
    request.set_form_data(body)
    #b64k = Base64.strict_encode64("#{ENV["SPOTIFY_CLIENT_ID"]}:#{ENV["SPOTIFY_CLIENT_SECRET"]}")
    #puts b64k
    #request.add_field("Authorization", "Basic " + b64k)
    response = http.request(request)
    data = JSON.parse(response.body)
    puts data.inspect

    user.spotify_token = data["access_token"]
    user.save
    

  end

  def self.get_spotify_user_premissions(user, code)

    body = {
      grant_type: 'authorization_code',
      code: code,
      redirect_uri: ENV['SERVER_URL'] + '/spotify',
      client_id: ENV['SPOTIFY_CLIENT_ID'],
      client_secret: ENV['SPOTIFY_CLIENT_SECRET']
    }

    uri = URI.parse('https://accounts.spotify.com/api/token')
    http = Net::HTTP.new(uri.host, uri.port)
    http.use_ssl = true
    request = Net::HTTP::Post.new(uri.path)
    request.set_form_data(body)
    response = http.request(request)

    return JSON.parse(response.body)

  end

  def self.play_song(codes, user, force_stop= false)

    body = {
      uris: codes
    }.to_json
    puts "play song for urls: #{codes}"
    uri = URI.parse("https://api.spotify.com/v1/me/player/play")
    http = Net::HTTP.new(uri.host,uri.port)
    http.use_ssl = true
    request = Net::HTTP::Put.new(uri.path)
    request.body = body;
    request.add_field("Authorization", "Bearer " + user.spotify_token)
    response = http.request(request)
    if response.code == "401" && !force_stop
      self.refresh_spotify_token(user)
      self.play_song(codes, user,true)
    end

  end


  def self.get_user_spotify_library(user,force_stop=false)

    uri = URI.parse('https://api.spotify.com/v1/me/tracks')
    
    song_data_list = []

    begin
      puts uri
      http = Net::HTTP.new(uri.host, uri.port)
      http.use_ssl = true
      request = Net::HTTP::Get.new(uri.request_uri)
      request.add_field('Authorization', 'Bearer ' + user.spotify_token)
      response = http.request(request)

      if response.code == "401" && !force_stop
        puts "refresh token and retry"
        self.refresh_spotify_token(user)
        return self.get_user_spotify_library(user,true)
      end

      data = JSON.parse(response.body)
      data['items'].each do |i|
        song = {}
        song["code"] = i['track']['id']
        song["name"] = i['track']['name']
        song["artist"] = i['track']['album']['artists'][0]['name']
        song["source"] = 'spotify'
        song_data_list.push(song)
      end
      uri = data['next'] ? URI.parse(data['next']) : ''
      puts data['items'].length
    end while data['next']

    return song_data_list

  end

  def self.get_user_playlists(user,force_stop=false)
    uri = URI.parse('https://api.spotify.com/v1/me/playlists')


    playlists = []
    data = {}
    begin
      http = Net::HTTP.new(uri.host, uri.port)
      http.use_ssl = true
      request = Net::HTTP::Get.new(uri.request_uri)
      request.add_field('Authorization', 'Bearer ' + user.spotify_token)
      response = http.request(request)

      if response.code == "401" && !force_stop
        puts "refresh token and retry"
        self.refresh_spotify_token(user)
        return self.get_user_playlists(user,true)
      end

      data = JSON.parse(response.body)
      playlists.concat data['items']
      uri = data['next'] ? URI.parse(data['next']) : ''
    end while data['next']
    s_user_id = data["href"].split("/")[5]
    puts playlists.length
    playlists = playlists.select{ |item| item["owner"]["id"] == s_user_id }
    puts playlists.length
    return playlists

  end

end
