# frozen_string_literal: true

class CategoryMetadataType < ApplicationRecord
  enum field_type: [:text_field, :number_field, :select_field]
  enum metadata_for: [:release, :torrent]
  belongs_to :category
end
