class DefaultWorker
  include Sidekiq::Worker

  def perform(*args)
    puts args
    args = args.first&.symbolize_keys || {}
    task = args.delete(:task)
    Rails.logger.debug("[SQ] DefaultWorker processing task #{task}")

    send(task, **args)
  end

  private

  def sync_offcloud_file_metadata
    OffcloudHistorySyncService.new.execute
  end

  def enqueue_downloads(**args)
    EnqueueDownloadsService.new(**args).execute
  end

  def download_path(**args)
    DownloadPathService.new(**args).execute
  end
end
