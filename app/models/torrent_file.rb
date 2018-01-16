# frozen_string_literal: true

require "digest"

class TorrentFile < ApplicationRecord
  belongs_to :torrent

  def torrent_data
    @torrent_data ||= BEncode.load(self.data)
  end

  def info_hash
    info = torrent_data["info"].bencode
    Digest::SHA1.hexdigest info
  end

  def length
    torrent_data["info"]["length"]
  end

  def name
    torrent_data["info"]["name"]
  end

  def files
    torrent_data["info"]["files"]
  end

  def self.from_raw(raw)
    raw_torrent = BEncode.load(raw)
    # The following properties do not affect the infohash:
    # anounce-list is an unofficial extension to the protocol
    # that allows for multiple trackers per torrent
    raw_torrent["info"].delete("announce-list")
    raw_torrent.delete("announce-list")
    # Bitcomet & Azureus cache peers in here
    raw_torrent["info"].delete("nodes")
    # Azureus stores the dht_backup_enable flag here
    raw_torrent["info"].delete("azureus_properties")
    # Remove web-seeds
    raw_torrent["info"].delete("url-list")
    # Remove libtorrent resume info
    raw_torrent["info"].delete("libtorrent_resume")
    raw_torrent["info"]["private"] = 1
    TorrentFile.new(data: raw_torrent.bencode)
  end
end
