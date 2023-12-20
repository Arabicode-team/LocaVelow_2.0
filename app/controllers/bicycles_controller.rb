class BicyclesController < ApplicationController
  before_action :set_bicycle, only: %i[edit update destroy]
  before_action :authenticate_user!, except: [:index, :show, :bicycles_filtered]

  def index
    if params[:ne_lat] && params[:ne_lng] && params[:sw_lat] && params[:sw_lng]
      ne_lat, ne_lng, sw_lat, sw_lng = params.values_at('ne_lat', 'ne_lng', 'sw_lat', 'sw_lng').map(&:to_f)
      @bicycles = Bicycle.where("latitude <= ? AND latitude >= ? AND longitude <= ? AND longitude >= ?", ne_lat, sw_lat, ne_lng, sw_lng)
    else
      @bicycles = Bicycle.all
    end

    bicycles_as_json = @bicycles.map do |bicycle|
      bicycle.as_json.merge(image_url: bicycle.image_url)
    end

    respond_to do |format|
      format.json { render json: bicycles_as_json }
      format.html do
        if request.xhr?
          render 'bicycles', layout: false
        end
      end
    end
  end

  def show
    @bicycle = Bicycle.find(params[:id])
  end

  def new
    @bicycle = Bicycle.new
  end

  def edit
  end

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

  def destroy
    if @bicycle.destroy
      redirect_to bicycles_path, notice: 'Le vélo a été supprimé avec succès.'
    else
      redirect_to bicycles_path, alert: @bicycle.errors.full_messages.to_sentence
    end
  end


    def bicycles_filtered
      start_datetime = DateTime.parse(params[:start_date])
      duration = params[:duration].to_i.hours
      end_datetime = start_datetime + duration
    
      ne_lat, ne_lng, sw_lat, sw_lng = params.values_at('ne_lat', 'ne_lng', 'sw_lat', 'sw_lng').map(&:to_f)
    
      @bicycles = Bicycle.filter_by_date_and_city(start_datetime, end_datetime)
                          .where("latitude <= ? AND latitude >= ? AND longitude <= ? AND longitude >= ?", 
                                  ne_lat, sw_lat, ne_lng, sw_lng)
    
      # Ответ в зависимости от типа запроса
      bicycles_as_json = @bicycles.map do |bicycle|
        bicycle.as_json.merge(image_url: bicycle.image_url)
      end
  
      respond_to do |format|
        format.json { render json: bicycles_as_json }
        format.html do
          if request.xhr?
            render 'bicycles_filtered', layout: false
          end
        end
      end
    end    
    
  private

  def set_bicycle
    @bicycle = Bicycle.find(params[:id])
  end

  def bicycle_params
    params.require(:bicycle).permit(:owner_id, :model, :bicycle_type, :size, :condition, :price_per_hour, :latitude, :longitude, :address, :city, :country, :postal_code, :state, :description, :image)
  end
end
