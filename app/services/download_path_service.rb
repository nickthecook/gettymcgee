# frozen_string_literal: true

class DownloadPathService
  class UnknownContentTypeError < StandardError; end
  class BadStatusError < StandardError; end
  class CanceledError < StandardError; end

  def initialize(path_id:)
    @path = Path.find(path_id)
  end

  def execute
    if @path.canceled?
      Rails.logger.info("Canceled download of Path #{@path.id}.")
      return
    end

    raise BadStatusError, "Path #{@path.id} is in state #{@path.status}; not downloading" unless @path.may_mark_downloading?

    if dest_dir.nil?
      Rails.logger.info("No content type for Path #{@path.id}; skipping.")
      return
    end

    update_path_size
    perform_download
  end

  private

  def update_path_size
    size = HTTParty.head(@path.url).content_length

    @path.update!(size: size)
  end

  def perform_download
    @path.mark_downloading!

    Rails.logger.info("Downloading Path #{@path.id} to '#{dest_dir}/#{@path.path}'...")
    client.download(@path.url, "#{dest_dir}/#{@path.path}") do |amount|
      raise CanceledError, "Download canceled" if @path.reload.canceled?

      @path.update!(amount: amount)
    end

    @path.mark_downloaded!
  rescue CanceledError
    Rails.logger.info("Canceled download of Path #{@path.id}.")
  rescue Errno::ECONNREFUSED => e
    SyncError.create!(failable: @path.id, message: e.to_s)
  end

  def dest_dir
    @dest_dir ||= path_for(@path.content_type)
  end

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
    @client ||= Offcloud::Client.new(Rails.logger)
  end
end
