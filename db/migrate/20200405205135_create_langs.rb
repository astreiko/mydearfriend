class CreateLangs < ActiveRecord::Migration[6.0]
  def change
    create_table :langs do |t|
      t.string :string

      t.timestamps
    end
  end
end
