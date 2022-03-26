class CreateApiCalls < ActiveRecord::Migration[6.1]
  def change
    create_table :api_calls do |t|
      t.integer :service
      t.integer :method
      t.string :url
      t.jsonb :request
      t.jsonb :response
      t.integer :status_code
      t.string :error

      t.timestamps
    end
  end
end
