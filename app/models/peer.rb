# frozen_string_literal: true

class Peer < ApplicationRecord
  belongs_to :user, optional: true
  belongs_to :torrent, optional: true

  def self.mark_inactive!
    Peer.where(active: true).where("updated_at < ?", 12.hours.ago).update(active: false)
  end
end
