# frozen_string_literal: true

class ApplicationMailer < ActionMailer::Base
  default from: "from@example.com"
  default host: Setting.tracker_hostname
  layout "mailer"
end


# class CustomDeviseMailer < Devise::Mailer
#   def confirmation_instructions(record, token, opts={})
#     @token = token
#     opts[:from] = "Dynamic Sender <dynamic@foo.com>"
#     devise_mail(record, :confirmation_instructions, opts)
#   end
# end