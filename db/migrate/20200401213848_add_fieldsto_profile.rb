class AddFieldstoProfile < ActiveRecord::Migration[5.2]
  def change
    add_column :profiles, :display_name, :string
    add_column :profiles, :github_name, :string
    add_column :profiles, :stackoverflow_name, :string
  end
end
