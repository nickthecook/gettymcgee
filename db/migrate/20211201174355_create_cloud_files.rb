class CreateCloudFiles < ActiveRecord::Migration[6.1]
  def change
    create_table :cloud_files do |t|
      t.string :remote_id
      t.string :filename
      t.integer :status
      t.string :original_link
      t.boolean :directory
      t.datetime :remote_created_at

      t.timestamps
    end

    add_index :cloud_files, :remote_id, unique: true
  end
end
