# frozen_string_literal: true

class OffcloudHistorySyncService
  def execute
    @files = client.fetch.files

    add_files
    remove_files
  end

  private

  def add_files(files)
    files.each do |file|
      cloud_file = CloudFile.find_by(remote_id: file.request_id)

      if cloud_file
        cloud_file.update_with_object(file)
      else
        cloud_file = CloudFile.from_object(file).save!
      end

      DefaultWorker.perform_async(task: "update_status", cloud_file_id: cloud_file.id) unless cloud_file.downloaded?
    end
  end

  def remove_files

  end

  def client
    @client ||= Offcloud::Client.new
  end
end
