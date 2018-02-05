# frozen_string_literal: true

class Peer < ApplicationRecord
  belongs_to :user, optional: true
  belongs_to :torrent, optional: true
end
