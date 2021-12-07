# frozen_string_literal: true

class OffcloudSyncPathsService
  def initialize(cloud_file_id:)
    @cloud_file = CloudFile.find(cloud_file_id)
  end

  def execute
    paths.count.times do |count|
      Path.create!(
        cloud_file: @cloud_file,
        path: paths[count],
        url: urls[count]
      )
    end
  rescue Offcloud::Client::RequestError => e
    raise unless e.to_s.match?(/ECONNREFUSED/)

    Rails.logger.error("Connection refused while syncing paths for CloudFile #{@cloud_file.id}: #{e}")
  end

  private

  def paths
    @paths ||= request(:files, @cloud_file.remote_id)
  end

  def urls
    @urls ||= request(:list, @cloud_file.remote_id)
  end

  def request(method, request_id)
    client.public_send(method, request_id)
  rescue Offcloud::Client::RequestError => e
    raise unless e.to_s.match?(/Bad archive"/)

    []
  end

  def client
    @client ||= Offcloud::Client.new
  end
end
