# frozen_string_literal: true

require "test_helper"

class InfoHashTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
  setup do
    @torrent = torrents(:one)
    @torrent.torrent_file.update(data: File.read(Rails.root.join("test", "fixtures", "hello.txt.torrent")))
    @peer = peers(:one)
  end

  test "it builds compact" do
    info_hash = InfoHash.new @torrent, "1234"

    assert info_hash.announce(true, nil, 1)["peers"] == [[@peer.ip.to_i, @peer.port.to_i].pack("Nn")].join
  end

  test "it builds normal" do
    info_hash = InfoHash.new @torrent, "1234"

    assert info_hash.announce(false, nil, 1)["peers"] == [{ ip: @peer.ip, port: @peer.port }]
  end

  test "it scrapes" do
    info_hash = InfoHash.new @torrent, "1234"
    assert info_hash.scrape[:files]["1234"] == { downloaded: 2, complete: 2, incomplete: 2, name: "one" }
  end
end
