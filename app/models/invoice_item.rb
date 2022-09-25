class InvoiceItem < ApplicationRecord
  belongs_to :invoice
  belongs_to :item
  enum   status: {pending: 0, packaged: 1, shipped: 2}
 
  validates_presence_of :item_id
  validates_numericality_of :item_id
  validates_presence_of :invoice_id
  validates_numericality_of :invoice_id
  validates_presence_of :quantity
  validates_numericality_of :quantity
  validates_presence_of :unit_price
  validates_numericality_of :unit_price
  validates_presence_of :status

  def discount_applied
  discount = InvoiceItem
    .select('bulk_discounts.id as discount_id, invoice_items.*')
    .where('invoice_items.id = ?', self.id)
    .joins(item: [{merchant: :bulk_discounts}])
    .where('invoice_items.quantity >= bulk_discounts.quantity_threshold')
    .order('bulk_discounts.quantity_threshold desc')
    .first
    
    if discount == nil
      return 'No discount applied'
    else
      discount.discount_id
    end
  end
end

