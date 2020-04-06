class ItemApp < ApplicationRecord
  belongs_to :item, optional: true
  belongs_to :group_add, optional: true

end
