class CreateItemApps < ActiveRecord::Migration[6.0]
  def change
    create_table :item_apps do |t|
      t.references :item, null: false, foreign_key: true
      t.references :group_app, null: false, foreign_key: true
      t.string :string
      t.text :text
      t.boolean :boolean
      t.date :date
      t.float :float

      t.timestamps
    end
  end
end
