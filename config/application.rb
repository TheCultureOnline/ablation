# frozen_string_literal: true

require_relative "boot"

require "rails/all"

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

module Ablation
  class Application < Rails::Application
    # Initialize configuration defaults for originally generated Rails version.
    config.load_defaults 5.1
    Dotenv::Railtie.load
    # Settings in config/environments/* take precedence over those specified here.
    # Application configuration should go into files in config/initializers
    # -- all .rb files in that directory are automatically loaded.
    unless Rails.application.secrets[:sentry_dsn].nil?
      Raven.configure do |config|
        config.dsn = Rails.application.secrets[:sentry_dsn]
      end
    end
    
  end
end
