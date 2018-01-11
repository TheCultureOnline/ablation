class CreateTorrents < ActiveRecord::Migration[5.1]
  def change
    create_table :torrents do |t|
      t.string :info_hash, null: false
      t.string :name, null: false
      t.integer :file_count, null: false
      t.text :file_list, array: true, null: false, default: []
      t.text :file_path, array: true, null: false, default: []
      t.integer :size, null: false, default: 0
      t.integer :leechers, null: false, default: 0
      t.integer :seeders, null: false, default: 0
      t.integer :leech
      t.integer :freeleech_type
      t.integer :snatched, null: false, default: 0
      t.bigint :balance

      t.references :release, foreign_key: true
      t.timestamp :last_reseed_request

      t.timestamps
    end

    add_index :torrents, :info_hash, unique: true
  end
end
