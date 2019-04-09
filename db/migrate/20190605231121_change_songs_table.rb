class ChangeSongsTable < ActiveRecord::Migration[5.2]
  def change
    remove_column :songs, :user_id
    remove_column :songs, :color
    create_table :library_songs do |t|
      t.text :color
      t.references :user, index: true, foreign_key: true
      t.references :song, index: true, foreign_key: true
      
 
      t.timestamps
    end
    drop_table :songs_tags
    create_table :library_songs_tags, id: false do |t|
      t.belongs_to :library_song, index: true
      t.belongs_to :tag, index: true
    end
    remove_column :played_songs, :track_feature_id
    add_reference :played_songs, :songs, index:true
    rename_table :track_features, :song_features
  end
end
