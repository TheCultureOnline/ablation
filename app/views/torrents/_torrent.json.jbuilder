# frozen_string_literal: true

json.extract! torrent, :id, :created_at, :updated_at
json.url torrent_url(torrent, format: :json)
