class UpdateRentalStatusJob < ApplicationJob
  queue_as :default

  def perform(*args)
    Rails.logger.info("UpdateRentalStatusJob started at #{Time.now}")

    begin
      Rental.all.each do |rental|
        rental.update_status_for_past_rentals
      end

      Rails.logger.info("UpdateRentalStatusJob finished at #{Time.now}")
    rescue => e
      Rails.logger.error("UpdateRentalStatusJob failed: #{e.message}")
      raise e
    end
  end
end
