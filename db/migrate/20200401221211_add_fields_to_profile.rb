class AddFieldsToProfile < ActiveRecord::Migration[5.2]
  def change
    add_column :profiles, :stackoverflow_userid, :string
  end
end
