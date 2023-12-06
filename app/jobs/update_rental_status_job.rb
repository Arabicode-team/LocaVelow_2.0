class UpdateRentalStatusJob < ApplicationJob
  queue_as :default

  def perform(*args)
    Rails.logger.info("UpdateRentalStatusJob started at #{Time.now}")
    Rental.all.each do |rental|
      rental.update_status_for_past_rentals
    end
    Rails.logger.info("UpdateRentalStatusJob finished at #{Time.now}")
  end
end
