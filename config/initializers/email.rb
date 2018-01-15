# frozen_string_literal: true

ActionMailer::Base.delivery_method = :smtp
ActionMailer::Base.smtp_settings = {
  address: "smtp.sendgrid.net",
  port: "587",
  authentication: :plain,
  user_name: "apikey",
  password: Rails.application.secrets.sendgrid_api_key,
  domain: Setting.hostname,
  enable_starttls_auto: true
}
