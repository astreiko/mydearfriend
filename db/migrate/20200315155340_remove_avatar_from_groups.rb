class RemoveAvatarFromGroups < ActiveRecord::Migration[6.0]
  def change

    remove_column :groups, :avatar, :string
  end
end
