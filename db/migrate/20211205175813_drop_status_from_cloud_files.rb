class DropStatusFromCloudFiles < ActiveRecord::Migration[6.1]
  def change
    remove_column :cloud_files, :status
  end
end
