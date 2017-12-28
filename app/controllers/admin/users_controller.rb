class Admin::UsersController < AdminController
  
    protected
  
      # Never trust parameters from the scary internet, only allow the white list through.
      def model_params
        params.require(:user).permit(:username, :email, :password)
      end

      def current_model
        User
      end

      def model_attributes
        [
            [:email, {type: "email"}],
            [:username, {type: "text"}],
        ]
      end

      def update_attributes
        [
            [:id, {type: "text", readonly: true}],
            [:created_at, {type: "text", readonly: true}],
            [:updated_at, {type: "text", readonly: true}],
        ]
      end

      def new_attributes
        [
            [:password, {type: "password"}],
        ]
      end

      def nav_links
        [
            ["List", [:admin, :users]],
            ["New", [:new, :admin, :user]]
        ]
      end
end
