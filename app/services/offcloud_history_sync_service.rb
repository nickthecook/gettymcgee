# frozen_string_literal: true

class OffcloudHistorySyncService
  def execute
    files = client.fetch.files

    files.each do |file|
      cloud_file = CloudFile.find_by(remote_id: file.request_id)

      if cloud_file
        cloud_file.update_with_object(file)
      else
        CloudFile.from_object(file).save!
      end
    end
  end

  private

  def client
    @client ||= Offcloud::Client.new
  end
end
