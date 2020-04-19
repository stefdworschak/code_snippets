class RemoveNamesFromUser < ActiveRecord::Migration[5.2]
  def change
    remove_column :profiles, :firstname
    remove_column :profiles, :lastname
    remove_column :profiles, :address
  end
end
