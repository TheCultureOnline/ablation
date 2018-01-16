

# frozen_string_literal: true

class RegistrationsController < Devise::RegistrationsController
  def create
    unless Setting.open_registration
      flash[:info] = "Registrations are not open yet, but please check back soon"
      redirect_to(new_user_session_path)
      return
    end
    super
  end
end
