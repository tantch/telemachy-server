class AddSpotifyTokenToUser < ActiveRecord::Migration[5.2]
  def change
    add_column :users, :spotify_token, :string
  end
end
