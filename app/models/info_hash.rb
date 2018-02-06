# frozen_string_literal: true

class InfoHash
  def initialize(torrent, raw_hash)
    @torrent = torrent
    @raw_hash = raw_hash
  end

  def announce(compact, peer_id, how_many_peers)
    {
        "interval" => Setting.announce_interval,
        "min interval" => Setting.min_interval,
        "peers" => peer_list(compact, how_many_peers, peer_id)
    }
  end

  def scrape
    sql = "WITH t AS (
        SELECT id, downloaded, completed, remaining
        FROM peers
        WHERE \"peers\".\"torrent_id\" = '#{@torrent.id}'
        AND (\"peers\".\"updated_at\" > NOW() - interval '#{Setting.announce_interval * 2} seconds')
    )
    SELECT (SELECT SUM(t.downloaded) from t) AS downloaded,
           (SELECT COUNT(t.completed) from t) AS completed,
           (SELECT COUNT(id) from t WHERE t.remaining != 0) AS incomplete"
    stats = ActiveRecord::Base.connection.execute(sql)[0]
    {
        files: {
            @raw_hash => {
                downloaded: (stats["downloaded"] || 0).to_i,
                complete: (stats["completed"] || 0).to_i,
                incomplete: (stats["incomplete"] || 0).to_i,
                name: @torrent.name,
            }
        }
    }
  end

  private
    def peers(how_many_peers)
      Peer
          .select(:ip, :port)
          .limit(how_many_peers)
          .where(torrent_id: @torrent.id)
          .where(active: true)
    end

    def peer_list(compact, how_many_peers, peer_id = nil)
      list = peers(how_many_peers).map do |peer|
        if compact
          [peer.ip.to_i, peer.port.to_i].pack("Nn")
        else
          {
            ip: peer.ip,
            port: peer.port,
          }.tap do |data|
            data[:peer_id] = peer_id if peer_id
          end
        end
      end
      if compact
        list.join
      else
        list
      end
    end
end
