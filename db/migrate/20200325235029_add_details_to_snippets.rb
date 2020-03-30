class AddDetailsToSnippets < ActiveRecord::Migration[5.2]
  def change
    add_column :snippets, :title, :string
    add_column :snippets, :code, :text
    add_reference :snippets, :user, foreign_key: true
  end
end
