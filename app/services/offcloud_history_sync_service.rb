# frozen_string_literal: true

class OffcloudHistorySyncService
  def execute
    @files = client.fetch.files

    add_files
    remove_files
  end

  private

  def add_files
    @files.each do |file|
      cloud_file = CloudFile.find_by(remote_id: file.request_id)

      unless cloud_file
        cloud_file = CloudFile.from_object(file)
        cloud_file.save!
      end

      DefaultWorker.perform_async(task: "update_status", cloud_file_id: cloud_file.id) unless cloud_file.deleted?
    end
  end

  def remove_files
    CloudFile.not_deleted.each do |cloud_file|
      cloud_file.mark_deleted! unless files_by_id[cloud_file.remote_id]
    end
  end

  def client
    @client ||= Offcloud::Client.new
  end

  def files_by_id
    @files_by_id ||= @files.each_with_object({}) do |file, hash|
      hash[file.request_id] = file
    end
  end
end
