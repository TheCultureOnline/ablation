class CreateTorrentMetadata < ActiveRecord::Migration[5.1]
  def change
    create_table :torrent_metadata do |t|
      t.references :torrent, foreign_key: true
      t.string :name
      t.text :value

      t.timestamps
    end
  end
end
