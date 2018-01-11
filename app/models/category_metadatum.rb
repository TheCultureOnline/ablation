# frozen_string_literal: true

class CategoryMetadatum < ApplicationRecord
  belongs_to :category
  enum data_type: [:string, :array, :text, :boolean, :integer]
end
