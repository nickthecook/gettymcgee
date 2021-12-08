# frozen_string_literal: true

class EnqueueDownloadsService
  def initialize(cloud_file_id:)
    @cloud_file = CloudFile.find(cloud_file_id)
  end

  def execute
    paths.each do |path|
      path_obj = Path.find_or_create_by!(cloud_file: @cloud_file, path: path)
      DownloadWorker.perform_async(task: "download_path", path_id: path_obj.id)
    end
  end

  private

  def paths
    @paths ||= client.files(@cloud_file.remote_id) || [@cloud_file.filename]
  end

  def client
    @client ||= Offcloud::Client.new
  end
end
