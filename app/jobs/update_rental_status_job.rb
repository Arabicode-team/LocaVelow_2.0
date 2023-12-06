class UpdateRentalStatusJob < ApplicationJob
  queue_as :default

  def perform
    Rails.logger.info("UpdateRentalStatusJob started at #{Time.now}")
    Rental.update_status_for_past_rentals
    Rails.logger.info("UpdateRentalStatusJob finished at #{Time.now}")
  end
end
