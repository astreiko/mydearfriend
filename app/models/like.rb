class Like < ApplicationRecord
  belongs_to :user
  belongs_to :item
  has_many :users
  has_many :items

end
