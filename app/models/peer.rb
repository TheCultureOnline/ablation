class Peer < ApplicationRecord
  belongs_to :user
  belongs_to :torrent
end
