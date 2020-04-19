class ChangeUserPasswordLength < ActiveRecord::Migration[5.2]
  def change
    change_column :users, :password, minimum: 6
  end
end
