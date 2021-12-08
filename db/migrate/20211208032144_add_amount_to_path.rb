class AddAmountToPath < ActiveRecord::Migration[6.1]
  def change
    add_column :paths, :amount, :bigint, default: 0
  end
end
