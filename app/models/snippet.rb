class Snippet < ApplicationRecord
  belongs_to :user
  has_many :comment
  validates :title, :presence => true
  validates :code, :presence => true
  validates :user_id, :presence => true
  validates_length_of :code, maximum: 512, allow_blank: false
end
