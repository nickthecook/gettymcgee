# frozen_string_literal: true

class CloudFile < ApplicationRecord
  class << self
    def from_object(obj)
      new(
        remote_id: obj.request_id,
        filename: obj.file_name,
        status: obj.status,
        original_link: obj.original_link,
        directory: obj.is_directory,
        remote_created_at: obj.created_on,
        server: obj.server,
        content_type: type_for(obj.file_name)
      )
    end

    def type_for(filename)
      return nil unless filename
      return :tv if filename.match?(/s\d\de\d\d/i) || filename.match?(/season[ _.]?\d/i) || filename.match?(/s\d\d/i)

      :movie
    end
  end

  has_many :paths

  enum content_type: %i[tv movie]
  enum status: %i[downloaded downloading]

  def update_with_object(obj)
    update!(
      filename: obj.file_name,
      status: obj.status,
      server: obj.server
    )
  end
end
