# frozen_string_literal: true

class DownloadPathService
  class UnknownContentTypeError < StandardError; end

  def initialize(path_id:)
    @path = Path.find(path_id)
  end

  def execute
    dest_dir = path_for(@path.content_type)
    if dest_dir.nil?
      Rails.logger.info("No content type for Path #{@path.id}; skipping.")
      return
    end

    client.download(@path.url, "#{dest_dir}/#{@path.path}")
  end

  private

  def path_for(content_type)
    return nil unless content_type

    dir = dir_for(content_type)
    dir += "/#{@path.cloud_file.filename}" if content_type != :tv

    dir
  end

  def dir_for(content_type)
    case content_type
    when :tv
      Rails.configuration.local_tv_dir
    when :movie
      Rails.configuration.local_movie_dir
    end
  end

  def client
    @client ||= Offcloud::Client.new
  end
end
