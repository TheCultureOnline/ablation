# frozen_string_literal: true

#
# config/initializers/scheduler.rb

require "rufus-scheduler"

# Let's use the rufus-scheduler singleton
#
s = Rufus::Scheduler.singleton


# update tracker stats
#
s.every "5m" do
  Rails.logger.debug { "Updating torent stats" }
  Torrent.update_stats!
end

s.every("10m") do
  User.update_stats!
end
# s.every("1h") do
#   Rails.logger.debug { "Flushing peers" }
#   Peer.where(active: false).where("updated_at < ?", 2.days.ago).delete_all
# end
