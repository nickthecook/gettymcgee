# frozen_string_literal: true

class DownloadFileService
  def initialize(cloud_file_id:)
    @cloud_file = CloudFile.find(cloud_file_id)
  end

  def execute
    return download_paths if @cloud_file.paths.any?

    download_file
  end

  private

  def download_paths
    @cloud_file.paths.each do |path|
      DefaultWorker.perform_async(task: "download_path", path_id: path.id)
    end
  end

  def download_file

  end

  def client
    @client ||= Offcloud::Client.new
  end
end
