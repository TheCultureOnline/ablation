# frozen_string_literal: true

require "bencode"

class TrackerController < ApplicationController
  def announce
    user = User.where(torrent_pass: params[:torrent_pass]).first
    failure("invalid torrent_pass specified") && (return) if user.nil?
    failure("info_hash is missing") && (return) if params["info_hash"].nil?
    failure("peer_id is missing") && (return) if params["peer_id"].nil?
    failure("port is missing") && (return) if params["port"].nil?
    failure("invalid info_hash") && (return) if params["info_hash"].bytesize != 20
    failure("invalid peer_id") && (return) if params["peer_id"].bytesize != 20
    hash = params[:info_hash].unpack("H*").first

    torrent = Torrent.where(info_hash: hash).first

    info_hash = InfoHash.new(hash, torrent)
    event! user, torrent
    announce = info_hash.announce(
      params[:compact].to_i == 1,
        params[:no_peer_id].to_i == 1,
        (params[:numwant] || Setting.default_peers).to_i
    )
    puts "announce: #{announce}"
    render plain: announce.bencode
  end

  def scrape
    user = User.where(torrent_pass: params[:torrent_pass]).first
    failure("invalid torrent_pass specified") && (return) if user.nil?
    #     content_type 'text/plain'
    if params[:info_hash]
      failure "invalid info_hash" if params[:info_hash].bytesize != 20
      hash = params[:info_hash].unpack("H*").first
      result = InfoHash.new(hash, Torrent.where(info_hash: hash).first).scrape
      puts "scrape result: #{result}"
      render plain: result.bencode
    else
      failure "no info_hash"
      #   InfoHash.scrape.bencode
    end
  end

    protected

      def failure(code = 400, reason)
        render plain: { "failure reason" => reason }.bencode, status: code
      end

      def event!(user, torrent)
        if params["event"] == "stopped"
          Peer.where(user_id: user.id, peer_id: params[:peer_id]).update_all(active: false)
        else
          ip = params[:ip] ||= request.env["REMOTE_ADDR"]
          peer = Peer.where(user_id: user.id, peer_id: params[:peer_id], torrent: torrent).first_or_initialize
          peer.update(
            active: true,
              ip: ip,
              downloaded: params[:downloaded].to_i,
              uploaded: params[:uploaded].to_i,
              remaining: params[:left].to_i,
              port: params[:port].to_i,
              completed: params[:left].to_i == 0,
              useragent: request.user_agent,
          )
        end
      end
end
