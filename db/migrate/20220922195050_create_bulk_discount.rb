class CreateBulkDiscount < ActiveRecord::Migration[5.2]
  def change
    create_table :bulk_discounts do |t|
      t.string :percentage_discount
      t.integer :quantity_threshold

      t.timestamps

      t.references :merchant, foreign_key: true
    end
  end
end
