

class RegistrationsController < Devise::RegistrationsController

  def create
    redirect_to new_user_session_path unless Setting.open_registration
    super
  end

end