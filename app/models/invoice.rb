class Invoice < ApplicationRecord
  has_many :transactions
  enum   status: {cancelled: 0, "in progress" => 1, completed: 2}
  has_many :transactions
  has_many :invoice_items
  has_many :items,   through: :invoice_items
  belongs_to :customer
  validates_presence_of :customer_id
  validates_presence_of :status
  validates_numericality_of :customer_id

  def self.incomplete_invoices
    select(:invoice_id).distinct.where.not(status: :shipped).pluck(:invoice_id)
  end
end
