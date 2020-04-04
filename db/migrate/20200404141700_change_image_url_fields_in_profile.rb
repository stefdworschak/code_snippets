class ChangeImageUrlFieldsInProfile < ActiveRecord::Migration[5.2]
  def change
    rename_column :profiles, :photo_url, :avatar_url
    rename_column :profiles, :photo_url_source, :avatar_url_source
  end
end
