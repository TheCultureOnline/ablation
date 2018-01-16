# frozen_string_literal: true

# RailsSettings Model
class Setting < RailsSettings::Base
  source Rails.root.join("config/app.yml")
  namespace Rails.env

  def self.open_registration
    puts "Calling open registration"
    super
  end
end
