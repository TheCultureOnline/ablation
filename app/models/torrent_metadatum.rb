# frozen_string_literal: true

class TorrentMetadatum < ApplicationRecord
  belongs_to :torrent
end
