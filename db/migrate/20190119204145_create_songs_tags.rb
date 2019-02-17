class CreateSongsTags < ActiveRecord::Migration[5.2]
  def change
    create_table :songs_tags, id: false do |t|
      t.belongs_to :song, index: true
      t.belongs_to :tag, index: true
    end
  end
end
