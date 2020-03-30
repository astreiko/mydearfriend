class AddItemsCountToGroups < ActiveRecord::Migration[6.0]
  def change
    add_column :groups, :items_count, :integer
  end
end
