class RenameCloudFilesRemoteStatusToStatus < ActiveRecord::Migration[6.1]
  def change
    rename_column :cloud_files, :remote_status, :status
  end
end
