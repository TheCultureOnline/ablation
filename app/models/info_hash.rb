class InfoHash
    def initialize id, torrent
        @id = id
        @torrent = torrent
    end

    def announce compact, peer_id, how_many_peers
        peers = Peer
            .limit(how_many_peers)
            .where(torrent_id: @torrent.id)
            .where(active: true)
        # peers = peers.where.not(peer_id: peer_id) if peer_id
        puts "About to return a peer_list of: #{peers.map do |peer|
            {
                ip: peer.ip,
                port: peer.port,
            }.tap do |data|
                data[:peer_id] = peer_id if peer_id
            end
        end}"
        peer_list = if compact
            peers.map do |peer|
                [peer.ip.to_i, peer.port.to_i].pack('Nn')
            end
        else
            peers.map do |peer|
                {
                    ip: peer.ip,
                    port: peer.port,
                }.tap do |data|
                    data[:peer_id] = peer_id if peer_id
                end
            end
        end

        {
            'interval' => Setting.announce_interval,
            'min interval' => Setting.min_interval,
            'peers' => compact ? peer_list.join : peer_list
        }
    end

    def scrape
        sql = "WITH t AS (
            SELECT id, downloaded, completed, remaining
            FROM peers
            WHERE \"peers\".\"torrent_id\" = 1
            AND (\"peers\".\"updated_at\" > NOW() - interval '#{Setting.announce_interval * 2} seconds')
        )
        SELECT (SELECT SUM(t.downloaded) from t) AS downloaded,
               (SELECT COUNT(t.completed) from t) AS completed, 
               (SELECT COUNT(id) from t WHERE t.remaining != 0) AS incomplete"
        stats = ActiveRecord::Base.connection.execute(sql)[0];
        puts stats
        {
            files: {
                @id => {
                    downloaded: stats['downloaded'],
                    complete: stats['completed'],
                    incomplete: stats['incomplete'],
                }
            }
        }
    end

end