class Merchant < ApplicationRecord
  has_many :items
  validates_presence_of :name

  def ready_to_ship
    items.select("items.*, invoice_items.status as not_shipped, invoices.created_at as created_at").joins(    invoices: :invoice_items).where.not("invoice_items.status = ?", 2)
  end
end
