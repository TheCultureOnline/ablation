# frozen_string_literal: true

class Admin::SearchFieldsController < AdminController
    protected

      # Never trust parameters from the scary internet, only allow the white list through.
      def model_params
        params.require(:search_field).permit(:name, :title, :sort_order, :options)
      end

      def current_model
        SearchField
      end

      def model_attributes
        [
            [:name, { type: "text_field" }],
            [:title, { type: "text_field" }],
            [:sort_order, { type: "number_field" }],
            [:options, { type: "text_area" }]
        ]
      end

      def nav_links
        [
            ["List", [:admin, :categories]],
            ["New", [:new, :admin, :category]]
        ]
      end
end
