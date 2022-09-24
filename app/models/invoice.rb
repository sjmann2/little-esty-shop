class Invoice < ApplicationRecord
  enum   status: {cancelled: 0, "in progress" => 1, completed: 2}
  has_many :transactions
  has_many :invoice_items
  has_many :items,   through: :invoice_items
  belongs_to :customer
  validates_presence_of :customer_id
  validates_presence_of :status
  validates_numericality_of :customer_id

  def self.incomplete_invoices
    joins(:invoice_items)
    .distinct
    .where
    .not("invoice_items.status = ?", 2)
    .order(:created_at)
  end

  def total_revenue
    invoice_items
    .sum("invoice_items.quantity * invoice_items.unit_price")
  end

  def discount
    invoice_items
    .joins(item: [{merchant: :bulk_discounts}])
    .where('quantity >= bulk_discounts.quantity_threshold')
    .sum('(quantity * invoice_items.unit_price) * (bulk_discounts.percentage_discount / 100.00)')
  end

  def discounted_revenue
    total_revenue - discount
  end
end
