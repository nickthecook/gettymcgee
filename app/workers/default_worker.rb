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

  def update_status(**args)
    OffcloudStatusUpdateService.new(**args).execute
  end

  def sync_offcloud_paths(**args)
    EnqueuePathSyncService.new(**args).execute
  end

  def sync_cloud_file_paths(**args)
    OffcloudSyncPathsService.new(**args).execute
  end

  def remove_cloud_file(**args)
    OffcloudRemoveFileService.new(**args).execute
  end
end
