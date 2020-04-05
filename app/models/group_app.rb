class GroupApp < ApplicationRecord
  belongs_to :group

  has_many :item_apps, dependent: :destroy

end
