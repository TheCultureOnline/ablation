# frozen_string_literal: true

class Torrent < ApplicationRecord
  has_one :torrent_file, dependent: :destroy
  has_many :peers
  belongs_to :release
  has_many :torrent_metadata, dependent: :destroy

  enum freeleech_type: []

  def self.from_file(path, release)
    torrent_file = TorrentFile.from_raw(File.read(path))

    torrent = Torrent.new(
      size: torrent_file.length,
      name: torrent_file.name,
      info_hash: torrent_file.info_hash,
      release_id: release.id,
    )
    # Setup file lists
    if torrent_file.name
      torrent.file_list << torrent_file.name
    end
    if torrent_file.files
      torrent_file.files.each do |f|
        torrent.file_list << f["path"]
      end
    end
    torrent.file_count = torrent.file_list.length
    torrent = Torrent.find_or_create_by!(torrent.attributes.delete_if { |k, v| v.blank? })
    torrent_file.torrent = torrent
    TorrentFile.find_or_create_by!(torrent_file.attributes.delete_if { |k, v| v.blank? })
    torrent
  end
end
