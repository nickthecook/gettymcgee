# frozen_string_literal: true

class BaseWorker
  include Sidekiq::Worker

  sidekiq_options queue: 'default'

  def perform(*args)
    puts args
    args = args.first&.symbolize_keys || {}
    task = args.delete(:task)
    Rails.logger.debug("[SQ] DefaultWorker processing task #{task}")

    send(task, **args)
  end
end
