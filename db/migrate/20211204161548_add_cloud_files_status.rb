class AddCloudFilesStatus < ActiveRecord::Migration[6.1]
  def change
    add_column :cloud_files, :status, :integer, default: 0
  end
end
