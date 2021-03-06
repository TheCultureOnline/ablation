# frozen_string_literal: true

class Torrent < ApplicationRecord
  has_one :torrent_file, dependent: :destroy
  has_many :peers, dependent: :destroy
  belongs_to :release
  delegate :category, to: :release
  has_many :torrent_metadata, dependent: :destroy

  enum freeleech_type: []

  def self.update_stats!
    ActiveRecord::Base.connection.execute("UPDATE torrents
      SET seeders = counts.seeders,
          leechers = counts.leechers
      FROM (
          SELECT torrent_id,
          (
              SELECT COUNT('X')
              FROM peers AS p1
              WHERE remaining = 0
              AND p1.torrent_id = peers.torrent_id
              AND active = true
          ) AS seeders,
          (
              SELECT COUNT('X')
              FROM peers AS p2
              WHERE remaining != 0
              AND p2.torrent_id = peers.torrent_id
              AND active = true
          ) AS leechers
          FROM peers
          WHERE active = true
      ) AS counts
      WHERE counts.torrent_id = torrents.id
      RETURNING torrents.id, torrents.seeders, torrents.leechers;")
  end

  def self.from_file(path, release)
    torrent_file = TorrentFile.from_raw(File.read(path))
    Torrent.from_torrent_file(torrent_file, release)
  end

  def self.from_url(url, release)
    torrent_file = TorrentFile.from_raw(open(url).read)
    Torrent.from_torrent_file(torrent_file, release)
  end

  def self.from_torrent_file(torrent_file, release)
    size = torrent_file.length || 0
    torrent = Torrent.new(
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
        size += f["length"] if torrent_file.length.nil?
        torrent.file_list << File.join(f["path"])
      end
    end
    torrent.size = size
    torrent.file_count = torrent.file_list.length
    # torrent = Torrent.find_or_create_by!(torrent.attributes.delete_if { |k, v| v.blank? })
    torrent_attrs = torrent.attributes.delete_if { |k, v| v.blank? }
    torrent = Torrent.where(info_hash: torrent.info_hash).first_or_initialize
    torrent.update(torrent_attrs)
    torrent_file.torrent = torrent
    TorrentFile.find_or_create_by!(torrent_file.attributes.delete_if { |k, v| v.blank? })
    torrent
  end

  # def leechers
  #   peers.where(active: true).where.not(remaining: 0).count
  # end

  # def seeders
  #   peers.where(active: true).where(remaining: 0).count
  # end
end
