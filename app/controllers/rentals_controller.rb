class RentalsController < ApplicationController
  before_action :set_rental, only: %i[ show edit update destroy ]

  # GET /rentals or /rentals.json
  def index
    @rentals = Rental.all
  end

  # GET /rentals/1 or /rentals/1.json
  def show
  end

  # GET /rentals/new
  def new
    @rental = Rental.new
  end

  # GET /rentals/1/edit
  def edit
  end

  # POST /rentals or /rentals.json
  def create
    @rental = Rental.new(rental_params)
    @rental.renter = current_user # или как вы определяете текущего пользователя
    @rental.total_cost = @rental.calculate_total_cost

  if @rental.valid?
    session[:rental_details] = @rental.attributes
    redirect_to confirm_rental_path
  else
    render :new, status: :unprocessable_entity
  end
  end

  def confirm
    Rails.logger.debug "Stripe session URL: #{@checkout_session_url}"

    @rental = Rental.new(session[:rental_details])

    @session = Stripe::Checkout::Session.create(
      payment_method_types: ['card'],
      line_items: [{
        price_data: {
          currency: 'usd',
          product_data: {
            name: 'Rental Payment',
          },
          unit_amount: (@rental.total_cost * 100).to_i, # Цена в центах
        },
        quantity: 1,
      }],
    mode: 'payment',
    success_url: rental_payment_success_url + '?session_id={CHECKOUT_SESSION_ID}',
    cancel_url: root_url
  )
  @checkout_session_url = @session.url

  end

  # PATCH/PUT /rentals/1 or /rentals/1.json
  def update
    respond_to do |format|
      if @rental.update(rental_params)
        format.html { redirect_to rental_url(@rental), notice: "Rental was successfully updated." }
        format.json { render :show, status: :ok, location: @rental }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @rental.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /rentals/1 or /rentals/1.json
  def destroy
    @rental.destroy!

    respond_to do |format|
      format.html { redirect_to rentals_url, notice: "Rental was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  def payment_success
    session_id = params[:session_id]
    stripe_session = Stripe::Checkout::Session.retrieve(session_id)
  
    if stripe_session.payment_status == 'paid'
      @rental = Rental.new(session[:rental_details])
      
      if @rental.save
        session.delete(:rental_details)
        redirect_to root_path, notice: 'Payment successful and rental confirmed!'
      else
        redirect_to root_path, alert: 'There was an error saving the rental.'
      end
    else
      redirect_to some_failure_path, alert: 'Payment failed.'
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_rental
      @rental = Rental.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def rental_params
      params.require(:rental).permit(:bicycle_id, :start_date, :end_date, :rental_status)
    end
end
