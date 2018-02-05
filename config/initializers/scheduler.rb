# frozen_string_literal: true

#
# config/initializers/scheduler.rb

require "rufus-scheduler"

# Let's use the rufus-scheduler singleton
#
s = Rufus::Scheduler.singleton


# update tracker stats
#
s.every "5m" do
  Rails.logger.debug { "Updating torent stats" }
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

s.every("1h") do
  Rails.logger.debug { "Flushing peers" }
  Peer.where(active: false).where("updated_at < ?", 12.hours.ago).delete_all
end
