class CreateTorrents < ActiveRecord::Migration[5.1]
  def change
    create_table :torrents do |t|
      t.string :info_hash
      t.string :name
      t.integer :file_count
      t.text :file_list, array: true, default: []
      t.text :file_path, array: true, default: []
      t.integer :size
      t.integer :leechers
      t.integer :seeders
      t.integer :leech
      t.integer :freeleech_type
      t.integer :snatched
      t.bigint :balance
      t.timestamp :last_reseed_request

      t.timestamps
    end

    create_index :torrents, :info_hash, unique: true
  end
end
