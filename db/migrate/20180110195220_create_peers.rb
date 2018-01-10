class CreatePeers < ActiveRecord::Migration[5.1]
  def change
    create_table :peers do |t|
      t.references :user, foreign_key: true
      t.references :torrent, foreign_key: true
      t.inet :ip, null: false
      t.boolean :active, null: false, default: true
      t.integer :announced, null: false, default: 0
      t.boolean :completed, null: false, default: false
      t.integer :downloaded, null: false, default: 0
      t.integer :uploaded, null: false, default: 0
      t.integer :remaining, null: false, default: 0
      t.integer :upspeed, null: false, default: 0
      t.integer :downspeed, null: false, default: 0
      t.integer :timespent, null: false, default: 0
      t.integer :corrupt, null: false, default: 0
      t.text :useragent, null: false, default: ""
      t.boolean :connectable, null: false, default: true
      t.binary :peer_id, null: false, default: 0x0 * 20
      t.integer :port, null: false

      t.timestamps
    end
  end
end
