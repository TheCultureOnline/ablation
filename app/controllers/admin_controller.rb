class AdminController < ApplicationController
    before_action :authorized?

    before_action :set_model, only: [:show, :edit, :update, :destroy]

    # GET /#{model}
    # GET /#{model}.json
    def index
      @models = current_model.all
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
        if @model.save
          format.html { redirect_to [:admin, @model], notice: "#{current_model.to_s} was successfully created." }
          format.json { render :show, status: :created, location: @model }
        else
          format.html { render :new }
          format.json { render json: @model.errors, status: :unprocessable_entity }
        end
      end
    end
  
    # PATCH/PUT /#{model}/1
    # PATCH/PUT /#{model}/1.json
    def update
      respond_to do |format|
        if @model.update(model_params)
          format.html { redirect_to [:admin, @model], notice: "#{current_model.to_s} was successfully updated." }
          format.json { render :show, status: :ok, location: @model }
        else
          format.html { render :edit }
          format.json { render json: @model.errors, status: :unprocessable_entity }
        end
      end
    end
  
    # DELETE /#{model}/1
    # DELETE /#{model}/1.json
    def destroy
      @model.destroy
      respond_to do |format|
        format.html { redirect_to [:admin, current_model], notice: 'User was successfully destroyed.' }
        format.json { head :no_content }
      end
    end
    
    private

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
