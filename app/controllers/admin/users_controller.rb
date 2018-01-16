# frozen_string_literal: true

class Admin::UsersController < AdminController
  # PATCH/PUT /#{model}/1
  # PATCH/PUT /#{model}/1.json
  def update
    respond_to do |format|
      if @model.update(model_params)
        bypass_sign_in @model if @model == current_user
        format.html { redirect_to [:admin, @model], notice: "#{current_model.to_s} was successfully updated." }
        format.json { render :show, status: :ok, location: @model }
      else
        format.html { render :edit }
        format.json { render json: @model.errors, status: :unprocessable_entity }
      end
    end
  end
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
            [:email, { type: "email_field" }],
            [:username, { type: "text_field" }],
            [:password, { type: "password_field" }]
        ]
      end

      def update_attributes
        [
            [:id, { type: "text_field", readonly: true }],
            [:created_at, { type: "text_field", readonly: true }],
            [:updated_at, { type: "text_field", readonly: true }],
        ]
      end

      def new_attributes
        [
            [:password, { type: "password" }],
        ]
      end

      def nav_links
        [
            ["List", [:admin, :users]],
            ["New", [:new, :admin, :user]]
        ]
      end
end
