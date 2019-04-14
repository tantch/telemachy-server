namespace :currently_playing do
  desc "Fetch my current playing information and stores it"
  
  task :fetch => :environment do
    spotifyController=SpotifyController.new
    spotifyController.fetchCurrentlyPlaying
  end
end
