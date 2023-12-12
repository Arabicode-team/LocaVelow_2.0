class BicyclesController < ApplicationController
  before_action :set_bicycle, only: %i[ edit update destroy ]

  # GET /bicycles or /bicycles.json
  def index
    @bicycles = Bicycle.all
  end

  # GET /bicycles/1 or /bicycles/1.json
  def show
    @bicycle = Bicycle.find(params[:id])
  end

  # GET /bicycles/new
  def new
    @bicycle = Bicycle.new
  end

  # GET /bicycles/1/edit
  def edit
  end

  # POST /bicycles or /bicycles.json
  def create
    @bicycle = Bicycle.new(bicycle_params)
    @bicycle.owner = current_user

    respond_to do |format|
      if @bicycle.save
        format.html { redirect_to bicycle_url(@bicycle), notice: "L'annonce a bien été créée" }
        format.json { render :show, status: :created, location: @bicycle }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @bicycle.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /bicycles/1 or /bicycles/1.json
  def update
    respond_to do |format|
      if @bicycle.update(bicycle_params)
        format.html { redirect_to bicycle_url(@bicycle), notice: "L'annonce a bien été modifiée" }
        format.json { render :show, status: :ok, location: @bicycle }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @bicycle.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /bicycles/1 or /bicycles/1.json
    def destroy
      if @bicycle.destroy
        redirect_to bicycles_path, alert: "L'annonce a bien été supprimée"
      else
        redirect_to bicycles_path, alert: @bicycle.errors.full_messages.to_sentence
      end
    end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_bicycle
      @bicycle = Bicycle.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def bicycle_params
      params.require(:bicycle).permit(:owner_id, :model, :bicycle_type, :size, :condition, :price_per_hour, :latitude, :longitude,
        :address, :city, :country, :postal_code, :state, :description, :image)
    end
   
end
