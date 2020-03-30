class AddTitleToGroups < ActiveRecord::Migration[6.0]
  def change
    add_column :groups, :title, :string
  end
end
