# frozen_string_literal: true

class AddRemotePathToPaths < ActiveRecord::Migration[6.1]
  def change
    add_column :paths, :url, :string
  end
end
