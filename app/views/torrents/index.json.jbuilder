# frozen_string_literal: true

json.array! @torrents, partial: "torrents/torrent", as: :torrent
