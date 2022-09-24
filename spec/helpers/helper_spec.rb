require "rails_helper"

RSpec.describe ApplicationHelper, :type => :helper do
  describe 'convert_to_dollars' do
    let!(:merchant_1) {create(:random_merchant)}
    let!(:customer_1) {create(:random_customer)}
    let!(:invoice_1) {customer_1.invoices.create!(status: 1)}
    let!(:invoice_2) {customer_1.invoices.create!(status: 1)}
    let!(:item_1) {merchant_1.items.create!(name: "10 lb bag of flour", description: "10 pounds of it", unit_price: 1000)}
    let!(:invoice_item_1) {InvoiceItem.create!(item: item_1, invoice: invoice_1, unit_price: 1000, quantity: 10, status: 2)}

    it 'returns an integer converted from cent value to dollar value' do
      expect(convert_to_dollars(invoice_item_1.unit_price)).to eq(10.0)
    end

    it 'returns 0 if an invoice has no items' do
      expect(convert_to_dollars(invoice_2.discounted_revenue)).to eq(0)
    end
  end
end