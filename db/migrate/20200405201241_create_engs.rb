class CreateEngs < ActiveRecord::Migration[6.0]
  def change
    create_table :engs do |t|
      t.string :string

      t.timestamps
    end
  end
end
