# frozen_string_literal: true

class Peer < ApplicationRecord
  belongs_to :user
  belongs_to :torrent
end
