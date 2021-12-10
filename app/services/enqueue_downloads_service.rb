# frozen_string_literal: true

class EnqueueDownloadsService
  def initialize(cloud_file_id:)
    @cloud_file = CloudFile.find(cloud_file_id)
  end

  def execute
    @cloud_file.paths.each do |path|
      next if path.skip?
      next unless path.may_enqueue_download?

      path.mark_enqueued!
      DownloadWorker.perform_async(task: "download_path", path_id: path.id)
    end
  end
end
