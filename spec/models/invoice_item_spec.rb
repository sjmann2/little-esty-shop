require "rails_helper"


RSpec.describe(InvoiceItem, type: :model) do
  let(:invoice_item) { InvoiceItem.new(    item_id: 539,     invoice_id: 1,     quantity: 12,     unit_price: 13635,     status: "pending") }

  describe 'relationships' do
    it {should belong_to(:invoice)}
    it {should belong_to(:item)}
  end

  it("is an instance of invoice_item") do
    expect(invoice_item).to(be_instance_of(InvoiceItem))
  end

  it 'has an enum for status' do
    expect(invoice_item.status).to be_a(String)
    expect(invoice_item.status).to_not eq(nil)
  end
end
