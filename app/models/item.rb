require 'elasticsearch/model'

class Item < ApplicationRecord
  belongs_to :group

  validates :text, presence: true
  validates :title, presence: true

  has_many :likes, dependent: :destroy
  has_many :comments, dependent: :destroy
  has_many :item_tags, dependent: :destroy
  has_rich_text :text

  include Elasticsearch::Model
  include Elasticsearch::Model::Callbacks
  settings index: { number_of_shards: 1 }


end
