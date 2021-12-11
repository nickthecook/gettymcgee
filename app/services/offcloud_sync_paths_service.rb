# frozen_string_literal: true

class OffcloudSyncPathsService
  def initialize(cloud_file_id:)
    @cloud_file = CloudFile.find(cloud_file_id)
  end

  def execute
    if paths.any?
      create_paths
    else
      create_default_path
    end

    DefaultWorker.perform_async(task: "enqueue_downloads", cloud_file_id: @cloud_file.id)
  rescue Offcloud::Client::RequestError => e
    case e.to_s
    when match?(/ECONNREFUSED/)
      Rails.logger.error("Connection refused while syncing paths for CloudFile #{@cloud_file.id}: #{e}")
    when match?(/Request not found/)
      Rails.logger.error("Remote file #{@cloud_file.remote_id} for CloudFile #{@cloud_file.id} not found on remote; marking local as deleted...")
      @cloud_file.mark_deleted!
    end
  end

  private

  def create_paths
    paths.count.times do |count|
      path = paths[count]
      size = sizes[count]

      path_only = CGI.unescape(path.rpartition(/\/\d+\//).last)

      Path.find_or_create_by!(cloud_file: @cloud_file, path: path_only, url: path, size: size)
    end
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
