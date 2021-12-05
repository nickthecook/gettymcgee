class CreatePaths < ActiveRecord::Migration[6.1]
  def change
    create_table :paths do |t|
      t.references :cloud_file
      t.string :path
      t.integer :status
      t.timestamps
    end
  end
end
