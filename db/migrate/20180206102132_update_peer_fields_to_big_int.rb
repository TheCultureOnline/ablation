class UpdatePeerFieldsToBigInt < ActiveRecord::Migration[5.1]
  def change
    change_column :peers, :downloaded, :bigint
    change_column :peers, :uploaded, :bigint
    change_column :peers, :remaining, :bigint
  end
end
