# frozen_string_literal: true

require "importer"
require "open-uri"

class P2P < Importer
  def initialize(username, password, key)
    @username = username
    @password = password
    @key = key
    super(
        "https://passthepopcorn.me",
        torrent: "torrents.php",
        login: "ajax.php?action=login",
        search: "search/%s/0/7/%d",
    )
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

  def import(torrent_result, auth_key)
    release = Release.where(
      category: Category.find_by(name: "Movies"),
    )
    if torrent_result["Year"]
      release = release.where(release_metadata: {
          name: "year",
          value: torrent_result["Year"]
      })
    end
    binding.pry if release.name == "year"
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
      torrent_url = "https://passthepopcorn.me/torrents.php?action=download&id=#{torrent_result["Id"]}&authkey=#{auth_key}&torrent_pass=#{@key}"
      torrent = Torrent.from_url(torrent_url, release)
      sleep 2
    end
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
