# frozen_string_literal: true

class CreateSyncErrors < ActiveRecord::Migration[6.1]
  def change
    create_table :sync_errors do |t|
      t.references :failable, polymorphic: true, null: false, index: true

      t.string :message, null: false

      t.timestamps
    end
  end
end
