class Torrent < ApplicationRecord
    has_one :torrent_file, dependent: :destroy
end
