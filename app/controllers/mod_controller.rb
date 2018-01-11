# frozen_string_literal: true

class ModController < ApplicationController
  before_action :authorized?

    private
      def authorized?
        unless User.can?(current_user, :moderator)
          flash[:error] = "You are not authorized to view that page."
          redirect_to root_path
        end
      end
end
