class Merchant < ApplicationRecord
  has_many :items
  has_many :invoice_items, through: :items
  has_many :invoices, through: :invoice_items
  has_many :customers, through: :invoices
  has_many :transactions, through: :invoices
  has_many :bulk_discounts

  validates_presence_of :name
  validates :enabled, inclusion: { in: [ true, false ] }

  def ready_to_ship    
    items
    .select("items.*, invoice_items.status, invoices.created_at")
    .joins( :invoices )
    .where.not("invoice_items.status = ?", 2)
    .order('invoices.created_at')
  end

  def top_day
    invoices.joins(:transactions)
    .where('transactions.result = 1')
    .select('DATE(invoices.created_at) as creation, sum(invoice_items.quantity * invoice_items.unit_price) as revenue')
    .group('creation')
    .order('revenue desc, creation desc')
    .first
    .creation
  end

  def favorite_customers
    items.select("customers.*, count(transactions.result) as transaction_count")
    .joins(invoices:[:transactions, :customer])
    .where(transactions: {result: 1})
    .group('customers.id')
    .order('transaction_count desc')
    .limit(5)
  end


  def self.top_5_revenue
    select('merchants.*, sum(invoice_items.quantity * invoice_items.unit_price) as revenue')
    .joins(:transactions)
    .where(transactions: {result: 1})
    .group(:id)
    .order('revenue desc')
    .limit(5)
  end

  def top_5_items
    items
    .joins(invoices: :transactions)
    .where(transactions: {result: 1})
    .select('items.*, sum(invoice_items.quantity * invoice_items.unit_price) as revenue')
    .group('items.id')
    .order('revenue desc')
    .limit(5)
  end
    
  def total_revenue
    invoice_items
    .where('invoice_items.status = 2')
    .sum("invoice_items.quantity * invoice_items.unit_price")
  end

  def discount
    Merchant.from(
      invoice_items
      .select('invoice_items.quantity * invoice_items.unit_price * MAX(bulk_discounts.percentage_discount) / 100.00 AS discount')
      .joins(item: [{merchant: :bulk_discounts}])
      .where('status = 2')
      .where('invoice_items.quantity >= bulk_discounts.quantity_threshold')
      .group('invoice_items.id, invoice_items.quantity, invoice_items.unit_price')
    )
    .sum('discount')
  end

  def discounted_revenue
    total_revenue - discount
  end
end
