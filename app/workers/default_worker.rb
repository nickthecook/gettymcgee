# frozen_string_literal: true

class DefaultWorker < BaseWorker
  private

  def sync_offcloud_file_metadata
    OffcloudHistorySyncService.new.execute
  end

  def enqueue_downloads(**args)
    EnqueueDownloadsService.new(**args).execute
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

  def clean_api_calls(**_args)
    CleanApiCallsService.new.execute
  end
end
