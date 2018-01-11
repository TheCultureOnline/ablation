# frozen_string_literal: true

require "rails-settings-ui"

#= Application-specific
#
# # You can specify a controller for RailsSettingsUi::ApplicationController to inherit from:
RailsSettingsUi.parent_controller = "AdminController" # default: '::ApplicationController'
#
# # Render RailsSettingsUi inside a custom layout (set to 'application' to use app layout, default is RailsSettingsUi's own layout)
# RailsSettingsUi::ApplicationController.layout 'admin'

Rails.application.config.to_prepare do
  # If you use a *custom layout*, make route helpers available to RailsSettingsUi:
  RailsSettingsUi.inline_main_app_routes!
  RailsSettingsUi.settings_class = "Setting"
end

# RailsSettingsUi.setup do |config|
#   # config.ignored_settings = [:company_name] # Settings not displayed in the interface
#   config.settings_class = "Setting" # Customize settings class name
#   # config.settings_displayed_as_select_tag = [:mode] # Settings displayed as select tag instead of checkbox group field
#   # config.defaults_for_settings = {mode: :manual} # Default option values for select tags
#   # config.engine_name = "your engine name" # Default use 'main_app', if you mount this engine to another engine, then set name of engine
# end
