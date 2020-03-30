class AddItemsCount2ToGroups < ActiveRecord::Migration[6.0]
  def change
    change_column_default :groups, :items_count, 0
  end
end


