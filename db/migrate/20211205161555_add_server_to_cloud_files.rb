# frozen_string_literal: true

class AddServerToCloudFiles < ActiveRecord::Migration[6.1]
  def change
    add_column :cloud_files, :server, :string
  end
end
