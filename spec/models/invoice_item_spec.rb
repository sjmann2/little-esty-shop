require "rails_helper"


RSpec.describe InvoiceItem, type: :model do
  let(:invoice_item) { InvoiceItem.new(item_id: 539, invoice_id: 1, quantity: 12, unit_price: 13635, status: "pending") }

  describe "relationships" do
    it { should belong_to(:invoice) }
    it { should belong_to(:item) }
  end

  describe "validations" do
    it { should validate_presence_of(:item_id) }
    it { should validate_presence_of(:invoice_id) }
    it { should validate_presence_of(:quantity) }
    it { should validate_presence_of(:unit_price) }
    it { should validate_presence_of(:status) }
    it { should validate_numericality_of(:item_id) }
    it { should validate_numericality_of(:invoice_id) }
    it { should validate_numericality_of(:quantity) }
    it { should validate_numericality_of(:unit_price) }
  end

  it "has an enum for status" do
    expect(invoice_item.status).to(be_a(String))
    expect(invoice_item.status).to_not(eq(nil))
  end

  describe 'instance methods' do
    describe 'discount_applied' do
      it 'returns the bulk discount applied for an invoice item' do
        merchant_1 = create(:random_merchant)
        customer_1 = create(:random_customer)
        invoice_1 = customer_1.invoices.create!(status: 1)
        bulk_discount_1 = merchant_1.bulk_discounts.create!(percentage_discount: 20, quantity_threshold: 10)
        item_1 = merchant_1.items.create!(name: "Lemons", description: "Sour", unit_price: 100)
        item_2 = merchant_1.items.create!(name: "Limes", description: "Citrus", unit_price: 100)
        invoice_item_1 = InvoiceItem.create!(item: item_1, invoice: invoice_1, unit_price: 100, quantity: 10, status: 2)
        invoice_item_2 = InvoiceItem.create!(item: item_2, invoice: invoice_1, unit_price: 100, quantity: 5, status: 2)

        expect(invoice_item_1.discount_applied).to eq(bulk_discount_1.id)
      end

      it "returns 'No Discount Applied' if an invoice item did not qualify for any discounts" do
        merchant_1 = create(:random_merchant)
        customer_1 = create(:random_customer)
        invoice_1 = customer_1.invoices.create!(status: 1)
        bulk_discount_1 = merchant_1.bulk_discounts.create!(percentage_discount: 20, quantity_threshold: 10)
        item_1 = merchant_1.items.create!(name: "Lemons", description: "Sour", unit_price: 100)
        item_2 = merchant_1.items.create!(name: "Limes", description: "Citrus", unit_price: 100)
        invoice_item_1 = InvoiceItem.create!(item: item_1, invoice: invoice_1, unit_price: 100, quantity: 10, status: 2)
        invoice_item_2 = InvoiceItem.create!(item: item_2, invoice: invoice_1, unit_price: 100, quantity: 5, status: 2)

        expect(invoice_item_2.discount_applied).to eq('No discount applied')
      end

      it 'returns the discount applied if an invoice has multiple merchants and multiple discounts applied' do
        merchant_5 = create(:random_merchant)
        merchant_6 = create(:random_merchant)
        customer_1 = create(:random_customer)
        bulk_discount_7 = merchant_5.bulk_discounts.create!(percentage_discount: 20, quantity_threshold: 10)
        bulk_discount_8 = merchant_5.bulk_discounts.create!(percentage_discount: 30, quantity_threshold: 15)
        invoice_5 = customer_1.invoices.create!(status: 1)
        item_9 = merchant_5.items.create!(name: "Spoons", description: "Hold food", unit_price: 200)
        item_10 = merchant_5.items.create!(name: "Toe rings", description: "Stylish", unit_price: 500)
        item_11 = merchant_6.items.create!(name: "Fake spiders", description: "Spooky", unit_price: 350)
        invoice_item_9 = InvoiceItem.create!(item: item_9, invoice: invoice_5, unit_price: 200, quantity: 12, status: 2)
        invoice_item_10 = InvoiceItem.create!(item: item_10, invoice: invoice_5, unit_price: 500, quantity: 15, status: 2)
        invoice_item_11 = InvoiceItem.create!(item: item_11, invoice: invoice_5, unit_price: 350, quantity: 15, status: 2)

        expect(invoice_item_9.discount_applied).to eq(bulk_discount_7.id)
        expect(invoice_item_10.discount_applied).to eq(bulk_discount_8.id)
      end

    end
  end
end
