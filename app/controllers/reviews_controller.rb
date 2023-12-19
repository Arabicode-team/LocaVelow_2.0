class ReviewsController < ApplicationController
  before_action :set_review, only: %i[ show edit update destroy ]
  before_action :admin_only, only: %i[ index destroy ]
  before_action :authorize_user, only: [ :new :create ]

  # GET /reviews or /reviews.json
  def index
    @reviews = Review.all
  end

  # GET /reviews/1 or /reviews/1.json
  def show
  end

  # GET /reviews/new
  def new
    @review = Review.new
  end

  # GET /reviews/1/edit
  def edit
    unless current_user.id == @review.reviewer_user_id 
      #Note: Only the user who left the review is allowed to edit it
      flash[:alert] = "Accès refusé! Vous n'avez pas le droit d'accéder à cette page et/ou d'effectuer cette action."
      redirect_to root_path
    end
  end

  # POST /reviews or /reviews.json
  def create
    @review = Review.new(review_params)

    respond_to do |format|
      if @review.save
        format.html { redirect_to review_url(@review), notice: "L'avis a bien été déposé." }
        format.json { render :show, status: :created, location: @review }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @review.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /reviews/1 or /reviews/1.json
  def update
    respond_to do |format|
      if @review.update(review_params)
        format.html { redirect_to review_url(@review), notice: "L'avis a bien été modifié." }
        format.json { render :show, status: :ok, location: @review }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @review.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /reviews/1 or /reviews/1.json
  def destroy
    @review.destroy!

    respond_to do |format|
      format.html { redirect_to reviews_url, notice: "L'avis a bien été supprimé" }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_review
      @review = Review.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def review_params
      params.require(:review).permit(:rental_id, :reviewed_user_id, :reviewer_user_id, :rating, :review_text, :review_date)
    end

    def admin_only
      unless current_user.admin?
        flash[:alert] = "Accès refusé! Vous n'avez pas le droit d'accéder à cette page et/ou d'effectuer cette action."
        redirect_to root_path
      end
    end

    def authorize_user
      rental_id = params[:rental_id]
      redirect_to root_path, alert: "Accès refusé! Vous n'avez pas le droit d'accéder à cette page et/ou d'effectuer cette action." unless current_user.id == Rental.find(rental_id).renter_id || current_user.admin?
    end
end
