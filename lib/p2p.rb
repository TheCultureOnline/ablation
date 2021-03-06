# frozen_string_literal: true

require "importer"
require "open-uri"

class P2P < Importer
  def initialize(username, password, key, seedbox_url = nil, seedbox_user = nil, seedbox_pass = nil)
    @username = username
    @password = password
    @key = key
    super(
        "https://passthepopcorn.me",
        torrent: "torrents.php",
        login: "ajax.php?action=login",
        search: "search/%s/0/7/%d",
    )
    @seedbox_url = seedbox_url
    @seedbox_user = seedbox_user
    @seedbox_pass = seedbox_pass

    @base_user = User.first
  end

  def search(query, page = 1)
    params = {
        json: "noredirect",
        order_by: "relevance",
        order_way: "descending",
        page: page,
    }
    params[:searchstr] = query if query
    resp = request(@torrent, nil, params.to_query)
    JSON.parse resp.body
  end

  def freeleech(page = 1)
    params = {
        freetorrent: 1,
        json: "noredirect",
        order_by: "relevance",
        order_way: "descending",
        page: page,
    }
    resp = request(@torrent, nil, params.to_query)
    JSON.parse resp.body
  end

  def import_freeleech(page = 1)
    free = freeleech(page)
    auth_key = free["AuthKey"]
    free["Movies"].each do |release|
      import(release, auth_key)
    end
  end

  def import(torrent_result, auth_key, freeleech = false)
    release = Release.where(
      category: Category.find_by(name: "Movies"),
    )
    if torrent_result["Year"]
      release = release.joins(:release_metadata).where(release_metadata: {
          name: "year",
          value: torrent_result["Year"]
      })
    end
    release = release.where(
      name: torrent_result["Title"],
    ).first_or_create!
    [
        ["year", "Year"],
        ["covert art", "Cover"],
        ["Imdb ID", "ImdbId"]
    ].each do |internal_name, external_name|
      d = ReleaseMetadatum.where(
        release: release,
        name: internal_name,
      ).first_or_initialize
      d.value = torrent_result[external_name]
      d.save
    end
    torrent_result["Torrents"].each do |torrent_result|
      if freeleech
        next unless torrent_result["FreeleechType"] == "Freeleech"
      end
      next if release.torrents.where(name: torrent_result["ReleaseName"]).any?
      torrent_url = "https://passthepopcorn.me/torrents.php?action=download&id=#{torrent_result["Id"]}&authkey=#{auth_key}&torrent_pass=#{@key}"
      P2P.seedbox(torrent_url, false, @seedbox_url, @seedbox_user, @seedbox_pass)
      torrent = Torrent.from_url(torrent_url, release)
      internal_url = "#{Setting.site_protocol}://#{Setting.site_hostname}:#{Setting.site_port}/torrents/#{torrent.id}.torrent?torrent_pass=#{@base_user.torrent_pass}"
      P2P.seedbox(internal_url, true, @seedbox_url, @seedbox_user, @seedbox_pass)
      sleep 2
    end
  end

  def self.seedbox(torrent_url, start_paused = true, seedbox_url = nil, seedbox_user = nil, seedbox_pass = nil)
    return if seedbox_url.nil?
    parsed_url = URI(seedbox_url)
    parsed_url.query = {
        torrents_start_stopped: 1,
    }.to_query if start_paused

    http = Net::HTTP.new(parsed_url.host, parsed_url.port)
    request = Net::HTTP::Post.new(parsed_url.request_uri)
    request.basic_auth seedbox_user, seedbox_pass if seedbox_user && seedbox_pass
    request.form_data = {
        url: torrent_url,
    }
    http.request(request)
  end

  def login_params
    {
        'username': @username,
        'password': @password,
        'passkey': @key,
        'keeplogged': "1",
        'login': "Login"
    }
  end

  def login_success?(output)
    begin
      res = JSON.parse output.body
      res["Result"].downcase == "ok"
    rescue
      return false
    end
  end
end
