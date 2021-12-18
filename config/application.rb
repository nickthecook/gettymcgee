require_relative "boot"

require "rails/all"

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

module Gettymcgee
  class Application < Rails::Application
    # Initialize configuration defaults for originally generated Rails version.
    config.load_defaults 6.1

    # Configuration for the application, engines, and railties goes here.
    #
    # These settings can be overridden in specific environments using the files
    # in config/environments, which are processed later.
    #
    config.time_zone = "Central Time (US & Canada)"
    config.eager_load_paths << Rails.root.join("extras")
    config.eager_load_paths << Rails.root.join("lib")
    config.autoload_paths << Rails.root.join("lib")

    config.local_content_dir = ENV["LOCAL_STORAGE_DIR"] || Rails.root.join("content")
    config.local_tv_dir = "#{config.local_content_dir}/#{ENV.fetch("LOCAL_TV_DIR") { "tv" }}"
    config.local_movie_dir = "#{config.local_content_dir}/#{ENV.fetch("LOCAL_MOVIE_DIR") { "movies" }}"

    logger = ActiveSupport::Logger.new($stdout)
    logger.formatter = config.log_formatter
    config.logger = ActiveSupport::TaggedLogging.new(logger)
    config.log_level = :INFO

    config.hosts << "xenon"
  end
end
