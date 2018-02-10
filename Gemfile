# frozen_string_literal: true

source "https://rubygems.org"

git_source(:github) do |repo_name|
  repo_name = "#{repo_name}/#{repo_name}" unless repo_name.include?("/")
  "https://github.com/#{repo_name}.git"
end


# Bundle edge Rails instead: gem 'rails', github: 'rails/rails'
gem "rails", "~> 5.1.4"
# Use postgresql as the database for Active Record
gem "pg", "~> 0.18"
# Use Puma as the app server
gem "puma", "~> 3.7"
# Use SCSS for stylesheets
gem "sass-rails", "~> 5.0"
# Use Uglifier as compressor for JavaScript assets
gem "uglifier", ">= 1.3.0"
# See https://github.com/rails/execjs#readme for more supported runtimes
# gem 'therubyracer', platforms: :ruby

# Use CoffeeScript for .coffee assets and views
gem "coffee-rails", "~> 4.2"
# Turbolinks makes navigating your web application faster. Read more: https://github.com/turbolinks/turbolinks
gem "turbolinks", "~> 5"
# Build JSON APIs with ease. Read more: https://github.com/rails/jbuilder
gem "jbuilder", "~> 2.5"
# Use Redis adapter to run Action Cable in production
gem "redis", "~> 3.0"
# Use ActiveModel has_secure_password
# gem 'bcrypt', '~> 3.1.7'

# Use Capistrano for deployment
# gem 'capistrano-rails', group: :development

# gem 'devise',               '~> 4.3.0'
gem "devise", git: "https://github.com/plataformatec/devise" # , ref: '88e9a85'

gem "bencode"
gem "will_paginate"

# Settings
gem "rails-settings-cached"
gem "rails-settings-ui"

# Style
gem "foundation-rails"
gem "jquery-rails"
gem "will_paginate-foundation"
gem "tinymce-rails"
gem "font-awesome-rails"

gem "sunspot_rails"
gem "progress_bar", require: false

# Monitoring
gem "newrelic_rpm"

# Catch Errors
gem "sentry-raven", group: :production

gem "rufus-scheduler"

gem "peek"
gem "peek-performance_bar"
gem "peek-gc"
gem "peek-pg"

group :development, :test do
  gem "dotenv-rails"
  gem "pry"
  gem "rubocop", require: false
  gem "rubocop-rails", require: false
  gem "brakeman", require: false
  # Call 'byebug' anywhere in the code to stop execution and get a debugger console
  gem "byebug", platforms: [:mri, :mingw, :x64_mingw]
  # Adds support for Capybara system testing and selenium driver
  gem "capybara", "~> 2.13"
  gem "selenium-webdriver"
  gem "coveralls", require: false
  gem "rails-controller-testing"
end

group :development do
  gem "scout_apm"
  # gem "sunspot_solr" # optional pre-packaged Solr distribution for use in development
  # Access an IRB console on exception pages or by using <%= console %> anywhere in the code.
  gem "web-console", ">= 3.3.0"
  gem "rails_layout"
  gem "listen", ">= 3.0.5", "< 3.2"
  # Spring speeds up development by keeping your application running in the background. Read more: https://github.com/rails/spring
  gem "spring"
  gem "spring-watcher-listen", "~> 2.0.0"
end

# Windows does not include zoneinfo files, so bundle the tzinfo-data gem
gem "tzinfo-data", platforms: [:mingw, :mswin, :x64_mingw, :jruby]
