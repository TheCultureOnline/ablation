class AddMetricsToUser < ActiveRecord::Migration[5.1]
  def change
    add_column :users, :bonus_upload, :bigint
    add_column :users, :uploaded, :bigint
    add_column :users, :downloaded, :bigint
    add_column :users, :invites, :integer
    add_column :users, :bonus_points, :bigint
  end
end
