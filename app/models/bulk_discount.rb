class BulkDiscount < ApplicationRecord
  belongs_to :merchant
  validates_numericality_of :percentage_discount
  validates_numericality_of :quantity_threshold
end