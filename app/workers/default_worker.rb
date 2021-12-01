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

  def fetch_offcloud_file_data
    OffcloudFileFetcherService.new.execute
  end
end
