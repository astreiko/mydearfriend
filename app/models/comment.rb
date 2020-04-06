require 'elasticsearch/model'

class Comment < ApplicationRecord
  belongs_to :user
  belongs_to :item

  validates :body, presence: true

  serialize :body

  include Elasticsearch::Model
  include Elasticsearch::Model::Callbacks
  settings index: { number_of_shards: 1 }t

end
