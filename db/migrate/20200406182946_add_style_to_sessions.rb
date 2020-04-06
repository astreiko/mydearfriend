class AddStyleToSessions < ActiveRecord::Migration[6.0]
  def change
    add_column :sessions, :style, :string, default: "light"
  end
end
