class AddDetailsToFavourite < ActiveRecord::Migration[5.2]
  def change
    add_column :favourites, :description, :string
    add_reference :favourites, :snippet, foreign_key: true
    add_reference :favourites, :user, foreign_key: true
  end
end
