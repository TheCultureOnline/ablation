class AddIndexToPeerActive < ActiveRecord::Migration[5.1]
  def change
    add_index(:peers, :torrent_id, where: "active", name: "torrent_by_active")
  end
end
