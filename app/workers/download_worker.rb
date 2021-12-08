# frozen_string_literal: true

class DownloadWorker < BaseWorker
  sidekiq_options queue: 'download'

  private

  def download_path(**args)
    DownloadPathService.new(**args).execute
  end
end
