class AddSpotifyRefreshTokenToUser < ActiveRecord::Migration[5.2]
  def change
    add_column :users, :spotify_refresh_token, :string
  end
end
