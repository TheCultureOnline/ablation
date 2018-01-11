# frozen_string_literal: true

class Release < ApplicationRecord
  belongs_to :category
  has_many :torrents
  # searchable do
  #     text :name, stored: true
  #     integer :category_id
  # end
end
