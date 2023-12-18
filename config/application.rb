require_relative "boot"

require "rails/all"

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

module LocaVelow20
  class Application < Rails::Application
    # Initialize configuration defaults for originally generated Rails version.
    config.load_defaults 7.1

    # Please, add to the `ignore` list any other `lib` subdirectories that do
    # not contain `.rb` files, or that should not be reloaded or eager loaded.
    # Common ones are `templates`, `generators`, or `middleware`, for example.
    config.autoload_lib(ignore: %w(assets tasks))

    # Configuration for the application, engines, and railties goes here.
    #
    # These settings can be overridden in specific environments using the files
    # in config/environments, which are processed later.
    #
    # config.eager_load_paths << Rails.root.join("extras")

    # config/application.rb
    config.i18n.available_locales = [:en, :de, :fr]
    config.i18n.default_locale = :fr


    config.time_zone = "Paris"

    config.after_initialize do
      Rails.application.load_tasks
    
      Thread.new do
        loop do
          UpdateRentalStatusJob.new.perform
          sleep(60.minutes)
        end
      end
    end
  end
end
