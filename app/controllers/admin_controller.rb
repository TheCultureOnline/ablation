# frozen_string_literal: true

class AdminController < ApplicationController
  before_action :authorized?

  before_action :set_model, only: [:show, :edit, :update, :destroy]

  # GET /#{model}
  # GET /#{model}.json
  def index
    @models = current_model.page(params[:page].present? ? params[:page].to_i : 1).per_page(25)
  end

  # GET /#{model}/1
  # GET /#{model}/1.json
  def show
  end

  # GET /#{model}/new
  def new
    @model = current_model.new
  end

  # GET /#{model}/1/edit
  def edit
  end

  # POST /#{model}
  # POST /#{model}.json
  def create
    @model = current_model.new(model_params)

    respond_to do |format|
      respond_to_saved format, @model.save
    end
  end

  # PATCH/PUT /#{model}/1
  # PATCH/PUT /#{model}/1.json
  def update
    respond_to do |format|
      respond_to_saved format, @model.update(model_params)
    end
  end

  # DELETE /#{model}/1
  # DELETE /#{model}/1.json
  def destroy
    @model.destroy
    respond_to do |format|
      format.html { redirect_to show_path_parts(current_model), notice: "User was successfully destroyed." }
      format.json { head :no_content }
    end
  end

    private

      def respond_to_saved(format, saved)
        if saved
          format.html { redirect_to show_path_parts(@model), notice: "#{current_model.to_s} was successfully updated." }
          format.json { render :show, status: :ok, location: @model }
        else
          format.html { render :edit }
          format.json { render json: @model.errors, status: :unprocessable_entity }
        end
      end

      def show_path_parts(model)
        [:admin, model]
      end
      helper_method :show_path_parts

      def edit_path_parts(model)
        [:edit, :admin, model]
      end
      helper_method :edit_path_parts

      def new_path_parts
        [:new, :admin, current_model.to_s.underscore]
      end
      helper_method :new_path_parts

      def nav_links
        []
      end
      helper_method :nav_links

      def model_attributes
        []
      end
      helper_method :model_attributes

      def new_attributes
        []
      end
      helper_method :new_attributes

      def update_attributes
        []
      end
      helper_method :update_attributes

      def set_model
        @model = current_model.find(params[:id])
      end

      # Never trust parameters from the scary internet, only allow the white list through.
      def model_params
        fail("Missing `model_params` definition")
      end

      def current_model
        fail("Missing `current_model` definition")
      end
      helper_method :current_model

      def authorized?
        unless User.can?(current_user, :admin)
          flash[:error] = "You are not authorized to view that page."
          redirect_to root_path
        end
      end
end
