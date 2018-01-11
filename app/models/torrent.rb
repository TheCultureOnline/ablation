# frozen_string_literal: true

class Torrent < ApplicationRecord
  has_one :torrent_file, dependent: :destroy
  has_many :peers
  # searchable do
  #     text :name
  # end

  def self.from_file(path, category_id)
    raw = File.read(path)
    raw_torrent = BEncode.load(raw)


    # The following properties do not affect the infohash:
    # anounce-list is an unofficial extension to the protocol
    # that allows for multiple trackers per torrent
    raw_torrent["info"].delete("announce-list")
    # Bitcomet & Azureus cache peers in here
    raw_torrent["info"].delete("nodes")
    # Azureus stores the dht_backup_enable flag here
    raw_torrent["info"].delete("azureus_properties")
    # Remove web-seeds
    raw_torrent["info"].delete("url-list")
    # Remove libtorrent resume info
    raw_torrent["info"].delete("libtorrent_resume")
    raw_torrent["info"]["private"] = 1

    torrent_file = TorrentFile.new(data: raw_torrent.bencode)

    torrent = Torrent.new(
      size: raw_torrent["info"]["length"],
      name: raw_torrent["info"]["name"],
      info_hash: torrent_file.info_hash,
      category_id: category_id,
    )
    # Setup file lists
    if raw_torrent["info"]["name"]
      torrent.file_list << raw_torrent["info"]["name"]
    end
    if raw_torrent["info"]["files"]
      raw_torrent["info"]["files"].each do |f|
        torrent.file_list << f["path"]
      end
    end
    torrent.save!
    torrent_file.torrent = torrent
    torrent_file.save!
    torrent
  end
end
