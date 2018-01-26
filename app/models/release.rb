# frozen_string_literal: true

class Release < ApplicationRecord
  belongs_to :category
  has_many :torrents, dependent: :destroy
  has_many :release_metadata, dependent: :destroy
  # searchable do
  #     text :name, stored: true
  #     integer :category_id
  # end

  def stats
    @stats ||= Torrent.select('
      MAX("torrents"."size") AS size,
      MAX("torrents"."updated_at") AS updated,
      sum("torrents"."snatched") AS snatched,
      SUM("torrents"."seeders") AS seeders,
      SUM("torrents"."leechers") AS leechers
    '.gsub(/\n/, "")).where(release_id: id)[0]
  end
end
