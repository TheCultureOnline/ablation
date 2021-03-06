# frozen_string_literal: true

class Category < ApplicationRecord
  has_many :releases, dependent: :destroy
  has_many :category_metadata_types, dependent: :destroy
  has_many :search_fields, dependent: :destroy
  def music?
    name == "Music"
  end

  def software?
    name == "Software"
  end

  def movie?
    name == "Movies"
  end

  def tv?
    name == "TV Shows"
  end

  def ebook?
    name == "EBook"
  end
end
