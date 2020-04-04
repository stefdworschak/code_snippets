class AddPhotoUrlToProfile < ActiveRecord::Migration[5.2]
  def change
    add_column :profiles, :photo_url, :string
    add_column :profiles, :photo_url_source, :string
  end
end
