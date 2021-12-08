# frozen_string_literal: true

class AddSizeToPaths < ActiveRecord::Migration[6.1]
  def change
    add_column :paths, :size, :bigint
  end
end
