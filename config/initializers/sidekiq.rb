# frozen_string_literal: true

if ENV["RUN_SIDEKIQ"]
  cron_config = ENV["SIDEKIQ_CRON"]

  Redis.exists_returns_integer = true
  
  if cron_config
    Sidekiq::Cron::Job.destroy_all!
    Sidekiq::Cron::Job.load_from_hash JSON.parse(cron_config)
  end

  Sidekiq.configure_server do |config|
    config.redis = { url: ENV["REDIS_URL"] || "redis://localhost:6379" }
  end
end

Sidekiq.configure_client do |config|
  config.redis = { url: ENV["REDIS_URL"] || "redis://localhost:6379" }
end
