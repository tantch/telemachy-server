class AddUserToAlbum < ActiveRecord::Migration[5.2]
  def change
    add_reference :albums, :user, foreign_key: true
  end
end
