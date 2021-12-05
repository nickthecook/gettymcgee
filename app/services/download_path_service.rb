# frozen_string_literal: true

class DownloadPathService
  class UnknownContentTypeError < StandardError; end

  def initialize(path_id:)
    @path = Path.find(path_id)
  end

  def execute
    client.download(@path.cloud_file.remote_id, @path.server, @path.path, path_for(@path.content_type))
  end

  private

  def path_for(content_type)
    "#{dir_for(content_type)}/#{@path.path}"
  end

  def dir_for(content_type)
    case content_type
    when :tv
      Rails.configuration.local_tv_dir
    when :movie
      Rails.configuration.local_movie_dir
    else
      raise UnknownContentTypeError, "Unknown content type '#{content_type}' on Path #{@path.id}"
    end
  end

  def client
    @client ||= Offcloud::Client.new
  end
end
