class CreateGroupApps < ActiveRecord::Migration[6.0]
  def change
    create_table :group_apps do |t|
      t.string :title
      t.string :type
      t.references :group, null: false, foreign_key: true

      t.timestamps
    end
  end
end
