class RenameCloudFilesStatusToRemoteStatus < ActiveRecord::Migration[6.1]
  def change
    rename_column :cloud_files, :status, :remote_status
  end
end
