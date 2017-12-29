class Torrent < ApplicationRecord
    has_one :torrent_file, dependent: :destroy

    searchable do
        text :title
    end
end
