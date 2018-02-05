# frozen_string_literal: true

require "bencode"

class TrackerController < ApplicationController
  before_action :set_user
  before_action :validate_announce, only: :announce

  def announce
    hash = params[:info_hash].unpack("H*").first
    torrent = Torrent.select(:id, :info_hash, :release_id, :snatched).find_by(info_hash: hash)
    info_hash = InfoHash.new(torrent)
    event! @user_id, torrent
    announce = info_hash.announce(
      params[:compact].to_i == 1,
        params[:no_peer_id].to_i == 1,
        (params[:numwant] || Setting.default_peers).to_i
    )
    render plain: announce.bencode
  end

  def scrape
    if params[:info_hash]
      failure("invalid info_hash") && return if params[:info_hash].bytesize != 20
      hash = params[:info_hash].unpack("H*").first
      result = InfoHash.new(Torrent.find_by(info_hash: hash)).scrape
      render plain: result.bencode
    else
      failure("no info_hash")
      # Could return information on _all_ torrents?
    end
  end

    protected
      def set_user
        failure("invalid torrent_pass specified") && (return) if @user_id.nil?
      end

      def validate_announce
        failure("info_hash is missing") && (return) if params[:info_hash].nil?
        failure("peer_id is missing") && (return) if params[:peer_id].nil?
        failure("port is missing") && (return) if params[:port].nil?
        failure("invalid info_hash") && (return) if params[:info_hash].bytesize != 20
        failure("invalid peer_id") && (return) if params[:peer_id].bytesize != 20
      end

      def failure(code = 400, reason)
        render plain: { "failure reason" => reason }.bencode, status: code
      end

      def event!(user_id, torrent)
        if params["event"] == "stopped"
          Peer.where(user_id: user_id, peer_id: params[:peer_id]).update_all(active: false)
          # Peer.where(user_id: user_id, peer_id: params[:peer_id]).delete_all
        else
          ip = params[:ip] ||= request.env["REMOTE_ADDR"]
          peer = Peer.where(user_id: user_id, torrent: torrent).first_or_initialize
          new_peer = peer.new_record?
          # binding.pry
          peer.update(
            active: true,
              ip: ip,
              downloaded: params[:downloaded].to_i,
              uploaded: params[:uploaded].to_i,
              remaining: params[:left].to_i,
              port: params[:port].to_i,
              completed: params[:left].to_i == 0,
              user_agent: request.user_agent,
              peer_id: params[:peer_id],
          )
          # binding.pry
          torrent.increment!(:snatched) if new_peer
        end
      end

      def authenticate_user!
        @user_id = User.where(torrent_pass: params[:torrent_pass]).limit(1).pluck(:id)
      end

      def peek_enabled?
        false
      end
end
