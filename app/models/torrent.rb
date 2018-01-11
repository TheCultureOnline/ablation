# frozen_string_literal: true

class Torrent < ApplicationRecord
  has_one :torrent_file, dependent: :destroy
  has_many :peers
  # searchable do
  #     text :name
  # end
end
