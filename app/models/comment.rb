class Comment < ApplicationRecord
  belongs_to :user
  belongs_to :item
  validates :body, presence: true


  serialize :body
  attr_accessible :body


end
