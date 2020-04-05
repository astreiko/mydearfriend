class ChangeTypeInGroupApps < ActiveRecord::Migration[6.0]
  def change
    rename_column :group_apps, :type, :type_data
  end
end
