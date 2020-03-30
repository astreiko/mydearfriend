class CreateItems < ActiveRecord::Migration[6.0]
  def change
    create_table :items do |t|
      t.string :title
      t.text :text
      t.references :group, null: false, foreign_key: true

      t.timestamps
    end
  end
end
