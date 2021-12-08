# frozen_string_literal: true

class OffcloudSyncPathsService
  def initialize(cloud_file_id:)
    @cloud_file = CloudFile.find(cloud_file_id)
  end

  def execute
    if paths.any?
      create_default_path
    else
      create_paths
    end

    DefaultWorker.perform_async(task: "enqueue_downloads", cloud_file_id: @cloud_file.id)
  end

  private

  def create_paths
    paths.count.times do |count|
      path = paths[count]
      size = sizes[count]

      path_only = CGI.unescape(path.rpartition(/\/\d+\//).last)

      Path.find_or_create_by!(cloud_file: @cloud_file, path: path_only, url: path, size: size)
    end
  rescue Offcloud::Client::RequestError => e
    raise unless e.to_s.match?(/ECONNREFUSED/)

    Rails.logger.error("Connection refused while syncing paths for CloudFile #{@cloud_file.id}: #{e}")
  end

  def create_default_path
    Path.find_or_create_by!(
      cloud_file: @cloud_file,
      path: @cloud_file.filename,
      url: default_url,
      size: @cloud_file.file_size
    )
  end

  def paths
    @paths ||= request(:files, @cloud_file.remote_id)
  end

  def sizes
    paths.map do |path|
      HTTParty.head(path).content_length
    end
  end

  def request(method, request_id)
    client.public_send(method, request_id)
  rescue Offcloud::Client::RequestError => e
    return [] if e.to_s.match?(/Bad archive"/)
    return [] if e.to_s.match?(/ECONNREFUSED/)

    raise
  end

  def default_url
    Offcloud::Client.url_for(
      @cloud_file.server,
      @cloud_file.remote_id,
      @cloud_file.filename
    )
  end

  def client
    @client ||= Offcloud::Client.new
  end
end
