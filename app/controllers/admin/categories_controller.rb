class Admin::CategoriesController < AdminController
  
    protected
  
      # Never trust parameters from the scary internet, only allow the white list through.
      def model_params
        params.require(:category).permit(:name, :description)
      end

      def current_model
        Category
      end

      def model_attributes
        [
            [:name, {type: "text_field"}],
            [:description, {type: "text_area"}],
        ]
      end

      def nav_links
        [
            ["List", [:admin, :categories]],
            ["New", [:new, :admin, :category]]
        ]
      end
end
