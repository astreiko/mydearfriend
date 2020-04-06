class AddLangToSessions < ActiveRecord::Migration[6.0]
  def change
    add_column :sessions, :lang, :string, default: "eng"
  end
end
