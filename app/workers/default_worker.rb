class DefaultWorker
  include Sidekiq::Worker

  def perform(*args)
    puts args
    args = args.first
    task = args.delete("task").to_sym
    Rails.logger.debug("[SQ] DefaultWorker processing task #{task}")

    send(task, **args)
  end

  private

  def sync_offcloud_file_metadata
    OffcloudHistorySyncService.new.execute
  end
end
