# frozen_string_literal: true

class Admin::CategoryMetadataTypesController < AdminController
    before_action :set_category

    def index
        super
        @models = @models.where(category: @category)
    end

  protected

    def set_category
        @category = Category.find(params[:category_id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def model_params
        p = params.require(:category_metadata_type).permit(:name, :field_type, :metadata_for, :options)
        p[:options] = p[:options].split(',').map(&:strip) if p[:options].present?
        p
    end

    def current_model
      CategoryMetadataType
    end

    def model_attributes
      [
          [:name, { type: "text_field" }],
          [:field_type, { type: "text_field" }],
          [:metadata_for, { type: "select", options: [:release, :torrent]}],
          [:options, { type: "text_area", format: [:join, ', ']}]
      ]
    end

    def nav_links
      [
          ["List", [:admin, :category_category_metadata_types]],
          ["New", [:new, :admin, :category_category_metadata_type]]
      ]
    end

    def show_path_parts model
        # admin_category_category_metadata_type_path(model.category, model)
        [:admin, @category, model]
    end

    def edit_path_parts model
        # edit_admin_category_category_metadata_type_path(model.category, model)
        [:edit, :admin, @category, model]
    end

    def new_path_parts
        # new_admin_category_category_metadata_type_path(category: @category)
        [:new, :admin, @category, current_model.to_s.underscore]
    end
end
