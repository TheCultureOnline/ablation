# frozen_string_literal: true

require "digest"

class TorrentFile < ApplicationRecord
  belongs_to :torrent

  def torrent_data
    BEncode.load(self.data)
  end

  def info_hash
    info = torrent_data["info"].bencode
    hash = Digest::SHA1.hexdigest info
  end
end
