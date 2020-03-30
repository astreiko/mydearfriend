class Topic < ApplicationRecord
  has_many :groups, dependent: :destroy
  validates :title, uniqueness: true

end
