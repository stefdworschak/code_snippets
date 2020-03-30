class AddDetailsToComments < ActiveRecord::Migration[5.2]
  def change
    add_column :comments, :comment_body, :text
    add_reference :comments, :snippet, foreign_key: true
    add_reference :comments, :user, foreign_key: true
  end
end
