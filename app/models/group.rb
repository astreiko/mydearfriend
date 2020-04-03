require 'elasticsearch/model'

class Group < ApplicationRecord

  belongs_to :user, optional: true
  belongs_to :topic
  has_one_attached :image
  has_many :items, dependent: :destroy

  include Elasticsearch::Model
  include Elasticsearch::Model::Callbacks


end
