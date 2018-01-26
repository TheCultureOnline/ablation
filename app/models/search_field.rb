# frozen_string_literal: true

class SearchField < ApplicationRecord
  enum kind: [:text_field_tag, :text_area_tag, :select_tag, :number_field_tag, :check_box_tag]
  enum search_type: [:all_types, :release, :torrent]
  belongs_to :category, optional: true
end
