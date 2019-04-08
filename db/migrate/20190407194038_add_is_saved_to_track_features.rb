class AddIsSavedToTrackFeatures < ActiveRecord::Migration[5.2]
  def change
    add_column :track_features, :isSaved, :boolean
  end
end
