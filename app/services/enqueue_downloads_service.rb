# frozen_string_literal: true

class EnqueueDownloadsService
  SKIP_EXTENSTIONS = %w[txt aria2].freeze

  def initialize(cloud_file_id:)
    @cloud_file = CloudFile.find(cloud_file_id)
  end

  def execute
    @cloud_file.paths.each do |path|
      next if skip?(path.path)
      next unless path.may_enqueue_download?

      path.mark_enqueued!
      DownloadWorker.perform_async(task: "download_path", path_id: path.id)
    end
  end

  private

  def skip?(path)
    SKIP_EXTENSTIONS.any? { |ext| path.match?(/\.#{ext}$/i) }
  end
end
