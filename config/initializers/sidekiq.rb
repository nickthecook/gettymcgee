# frozen_string_literal: true

require 'sidekiq/web'
Sidekiq::Web.app_url = "/"

if ENV["RUN_SIDEKIQ"]
  cron_config = ENV["SIDEKIQ_CRON"]

  Redis.exists_returns_integer = true

  Rails.application.reloader.to_prepare do
    Sidekiq.logger = Logger.new($stdout)
    Sidekiq.logger.level = Logger::INFO

    if cron_config
      Sidekiq::Cron::Job.destroy_all!
      Sidekiq::Cron::Job.load_from_hash JSON.parse(cron_config)
    end
  end

  Sidekiq.configure_server do |config|
    config.redis = { url: ENV["REDIS_URL"] || "redis://localhost:6379" }
  end
end

Sidekiq.configure_client do |config|
  config.redis = { url: ENV["REDIS_URL"] || "redis://localhost:6379" }
end
