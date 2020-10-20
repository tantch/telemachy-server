class AddTagsToAlbums < ActiveRecord::Migration[5.2]
  def change
    create_table :albums_tags, id: false do |t|
      t.belongs_to :album, index: true
      t.belongs_to :tag, index: true
    end
  end
end
