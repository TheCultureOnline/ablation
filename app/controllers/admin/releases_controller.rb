# frozen_string_literal: true

class Admin::ReleasesController < AdminController
  protected

    # Never trust parameters from the scary internet, only allow the white list through.
    def model_params
      params.require(:release).permit(:name, :year)
    end

    def current_model
      Release
    end

    def model_attributes
      [
          [:name, { type: "text_field" }],
          [:year, { type: "number_field" }],
      ]
    end

    def nav_links
      [
          ["List", [:admin, :releases]],
          ["New", [:new, :admin, :release]]
      ]
    end
end
