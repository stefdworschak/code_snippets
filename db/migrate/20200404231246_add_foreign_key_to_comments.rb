class AddForeignKeyToCommentsAndSnippets < ActiveRecord::Migration[5.2]
  def change
    remove_reference :comments, :snippet, foreign_key: true
    add_reference :comments, :snippet, foreign_key: true, on_delete: :cascade
    remove_reference :comments, :user, foreign_key: true
    add_reference :comments, :user, foreign_key: true, on_delete: :cascade
    remove_reference :snippets, :user, foreign_key: true
    add_reference :snippets, :user, foreign_key: true, on_delete: :cascade
  end
end
