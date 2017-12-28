class CreateTorrentFiles < ActiveRecord::Migration[5.1]
  def change
    create_table :torrent_files do |t|
      t.references :torrent, foreign_key: true
      t.binary :data

      t.timestamps
    end
  end
end
