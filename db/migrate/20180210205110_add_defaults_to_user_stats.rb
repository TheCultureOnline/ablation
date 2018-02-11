class AddDefaultsToUserStats < ActiveRecord::Migration[5.1]
  def change
    change_column :users, :bonus_upload, :bigint, default: 0
    change_column :users, :uploaded, :bigint, default: 0
    change_column :users, :downloaded, :bigint, default: 0
    change_column :users, :invites, :integer, default: 0
    change_column :users, :bonus_points, :bigint, default: 0
  end
end
