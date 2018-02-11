# frozen_string_literal: true

# This file is used by Rack-based servers to start the application.

require_relative "config/environment"
# require 'rack'
# require 'rack/cache'
# require 'redis-rack-cache'

# use Rack::Cache,
# metastore:   "#{ENV["REDIS_URL"]}/1/metastore",
# entitystore: "#{ENV["REDIS_URL"]}/1/entitystore"
run Rails.application
