class CloudFile < ApplicationRecord
  class << self
    def from_object(obj)
      self.new(
        remote_id: obj.request_id,
        filename: obj.file_name,
        remote_status: obj.status,
        original_link: obj.original_link,
        directory: obj.is_directory,
        remote_created_at: obj.created_on
      )
    end
  end

  enum remote_status: %i[downloaded]
end
