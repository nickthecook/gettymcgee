# frozen_string_literal: true

class AddAmountAndFileSizeToCloudFiles < ActiveRecord::Migration[6.1]
  def change
    add_column :cloud_files, :remote_amount, :bigint, default: 0
    add_column :cloud_files, :file_size, :bigint
  end
end
