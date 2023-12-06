class ApplicationJob < ActiveJob::Base
  # Automatically retry jobs that encountered a deadlock
  # retry_on ActiveRecord::Deadlocked

  # Most jobs are safe to ignore if the underlying records are no longer available
  # discard_on ActiveJob::DeserializationError
  config.after_initialize do
    Rails.application.load_tasks
    UpdateRentalStatusJob.set(wait: 15.minutes).perform_later
  end
end