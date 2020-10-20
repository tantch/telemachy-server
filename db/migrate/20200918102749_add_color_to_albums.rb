class AddColorToAlbums < ActiveRecord::Migration[5.2]
  def change
    add_column :albums, :color, :string
  end
end
