class Comment < ApplicationRecord
  belongs_to :snippet
  validates :comment_body, :presence => true
end
