# frozen_string_literal: true

class EnqueuePathSyncService
  def execute
    CloudFile.downloaded_without_paths.each do |cloud_file|
      DefaultWorker.perform_async(task: "sync_cloud_file_paths", cloud_file_id: cloud_file.id)
    end
  end
end
