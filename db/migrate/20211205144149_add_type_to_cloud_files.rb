class AddTypeToCloudFiles < ActiveRecord::Migration[6.1]
  def change
    add_column :cloud_files, :content_type, :integer
  end
end
