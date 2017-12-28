class AddTorrentPassToUser < ActiveRecord::Migration[5.1]
  def change
    add_column :users, :torrent_pass, :string
  end
end
