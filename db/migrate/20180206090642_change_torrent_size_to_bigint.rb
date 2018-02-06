class ChangeTorrentSizeToBigint < ActiveRecord::Migration[5.1]
  def change
    change_column :torrents, :size, :bigint
  end
end
