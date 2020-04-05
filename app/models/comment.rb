class Comment < ApplicationRecord
  belongs_to :snippet
  belongs_to :user
  validates :comment_body, :presence => true
  validates :user_id, :presence => true
  validates :snippet_id, :presence => true
end
