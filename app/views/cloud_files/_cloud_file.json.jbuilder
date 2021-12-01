json.extract! cloud_file, :id, :filename, :status, :original_link, :directory, :remote_created_at, :created_at, :updated_at
json.url cloud_file_url(cloud_file, format: :json)
