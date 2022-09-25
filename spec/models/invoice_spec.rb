require "rails_helper"


RSpec.describe(Invoice, type: :model) do
  let(:invoice) { Invoice.new(    customer_id: 1,     status: "in progress") }

  describe("relationships") do
    it { should(have_many(:transactions)) }
    it { should(belong_to(:customer)) }
    it { should(have_many(:invoice_items)) }
    it { should(have_many(:items).through(:invoice_items)) }
    it { should(validate_numericality_of(:customer_id)) }
  end

  describe("validations") do
    it { should(validate_presence_of(:customer_id)) }
    it { should(validate_presence_of(:status)) }
  end

  it("is an instance of invoice") do
    expect(invoice).to(be_instance_of(Invoice))
  end

  describe("relationships") do
    it { should(have_many(:transactions)) }
  end

  describe 'class methods' do
    describe 'incomplete_invoices' do
      it 'returns invoices for all items that have not been shipped' do
        5.times do
          create(:random_customer)
        end

        invoice_1 = create(:random_invoice, customer: Customer.all[0])
        invoice_2 = create(:random_invoice, customer: Customer.all[1])
        invoice_3 = create(:random_invoice, customer: Customer.all[2])
        invoice_4 = create(:random_invoice, customer: Customer.all[3])
        invoice_5 = create(:random_invoice, customer: Customer.all[4])

        merchant_1 = create(:random_merchant)
        merchant_2 = create(:random_merchant)

        item_1 = create(:random_item, merchant_id: merchant_1.id)
        item_2 = create(:random_item, merchant_id: merchant_1.id)
        item_3 = create(:random_item, merchant_id: merchant_1.id)
        item_4 = create(:random_item, merchant_id: merchant_2.id)
        item_5 = create(:random_item, merchant_id: merchant_2.id)

        invoice_item_1 = InvoiceItem.create!(item_id: item_1.id, invoice_id: invoice_1.id, quantity: 3, unit_price: 3635, status: 'shipped')
        invoice_item_2 = InvoiceItem.create!(item_id: item_2.id, invoice_id: invoice_2.id, quantity: 31, unit_price: 13635, status: 'packaged')
        invoice_item_3 = InvoiceItem.create!(item_id: item_3.id, invoice_id: invoice_3.id, quantity: 13, unit_price: 1335, status: 'shipped')
        invoice_item_4 = InvoiceItem.create!(item_id: item_4.id, invoice_id: invoice_4.id, quantity: 30, unit_price: 1335, status: 'pending')
        invoice_item_5 = InvoiceItem.create!(item_id: item_5.id, invoice_id: invoice_5.id, quantity: 12, unit_price: 1365, status: 'packaged')

        expect(Invoice.incomplete_invoices).to eq([invoice_2, invoice_4, invoice_5])
      end
    end
  end

  describe 'instance methods' do
    describe 'total_revenue' do
      it 'calculates the total revenue for each invoice' do
        customer_1 = create(:random_customer)

        invoice_1 = create(:random_invoice, customer: Customer.all[0])
        invoice_2 = create(:random_invoice, customer: Customer.all[0])

        merchant_1 = create(:random_merchant)

        item_1 = create(:random_item, merchant_id: merchant_1.id)
        item_2 = create(:random_item, merchant_id: merchant_1.id)
        item_3 = create(:random_item, merchant_id: merchant_1.id)

        invoice_item_1 = InvoiceItem.create!(item_id: item_1.id, invoice_id: invoice_1.id, quantity: 2, unit_price: 4999, status: 'shipped')
        invoice_item_2 = InvoiceItem.create!(item_id: item_2.id, invoice_id: invoice_1.id, quantity: 1, unit_price: 2001, status: 'shipped')
        invoice_item_3 = InvoiceItem.create!(item_id: item_3.id, invoice_id: invoice_1.id, quantity: 4, unit_price: 4575, status: 'shipped')

        expect(invoice_1.total_revenue).to eq(30299)
        expect(invoice_2.total_revenue).to eq(0)
      end
    end

    describe 'dicount/discounted revenue' do
      describe 'discount' do
        it 'returns no bulk discount if no items meet the quantity threshold' do
          merchant_1 = create(:random_merchant)
          customer_1 = create(:random_customer)
          invoice_1 = customer_1.invoices.create!(status: 1)
          bulk_discount_1 = merchant_1.bulk_discounts.create!(percentage_discount: 20, quantity_threshold: 10)
          item_1 = merchant_1.items.create!(name: "10 lb bag of flour", description: "10 pounds of it", unit_price: 1000)
          item_2 = merchant_1.items.create!(name: "Hair pins", description: "10 per pack", unit_price: 500)
          invoice_item_1 = InvoiceItem.create!(item: item_1, invoice: invoice_1, unit_price: 1000, quantity: 5, status: 2)
          invoice_item_2 = InvoiceItem.create!(item: item_2, invoice: invoice_1, unit_price: 500, quantity: 5, status: 2)

          expect(invoice_1.discount).to eq(0)
        end

        it 'returns the total bulk discount amount if one item meets the quantity threshold and one does not' do
          merchant_2 = create(:random_merchant)
          customer_1 = create(:random_customer)
          invoice_2 = customer_1.invoices.create!(status: 1)
          bulk_discount_2 = merchant_2.bulk_discounts.create!(percentage_discount: 20, quantity_threshold: 10)
          item_3 = merchant_2.items.create!(name: "Lemons", description: "Sour", unit_price: 100)
          item_4 = merchant_2.items.create!(name: "Limes", description: "Citrus", unit_price: 100)
          invoice_item_3 = InvoiceItem.create!(item: item_3, invoice: invoice_2, unit_price: 100, quantity: 10, status: 2)
          invoice_item_4 = InvoiceItem.create!(item: item_4, invoice: invoice_2, unit_price: 100, quantity: 5, status: 2)

          expect(invoice_2.discount).to eq(200)
        end

        it 'returns total bulk discount if one item meets one quantity threshold of one discount and a second item meets another' do
          merchant_3 = create(:random_merchant)
          customer_1 = create(:random_customer)
          invoice_3 = customer_1.invoices.create!(status: 1)
          bulk_discount_3 = merchant_3.bulk_discounts.create!(percentage_discount: 20, quantity_threshold: 10)
          bulk_discount_4 = merchant_3.bulk_discounts.create!(percentage_discount: 30, quantity_threshold: 15)
          item_5 = merchant_3.items.create!(name: "Rubber earring backs", description: "To hold your earrings in", unit_price: 400)
          item_6 = merchant_3.items.create!(name: "Trash bags", description: "To hold trash", unit_price: 900)
          invoice_item_5 = InvoiceItem.create!(item: item_5, invoice: invoice_3, unit_price: 400, quantity: 12, status: 2)
          invoice_item_6 = InvoiceItem.create!(item: item_6, invoice: invoice_3, unit_price: 900, quantity: 15, status: 2)

          expect(invoice_3.discount).to eq(5010)
          
        end

        it 'returns the highest percentage discount if two items quality for mulitple discounts' do
          merchant_4 = create(:random_merchant)
          customer_1 = create(:random_customer)
          invoice_4 = customer_1.invoices.create!(status: 1)
          bulk_discount_5 = merchant_4.bulk_discounts.create!(percentage_discount: 20, quantity_threshold: 10)
          bulk_discount_6 = merchant_4.bulk_discounts.create!(percentage_discount: 15, quantity_threshold: 15)
          item_7 = merchant_4.items.create!(name: "Twist ties", description: "Twist em", unit_price: 100)
          item_8 = merchant_4.items.create!(name: "Dice", description: "Roll em", unit_price: 200)
          invoice_item_7 = InvoiceItem.create!(item: item_7, invoice: invoice_4, unit_price: 100, quantity: 12, status: 2)
          invoice_item_8 = InvoiceItem.create!(item: item_8, invoice: invoice_4, unit_price: 200, quantity: 15, status: 2)
      
          expect(invoice_4.discount).to eq(840)
        end
      
        it 'returns the total percentage discount when an invoice has multiple merchants and discounts applied' do
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

          expect(invoice_5.discount).to eq(2730)
        end
      end

      describe 'discounted_revenue' do
        it 'calculates the total discounted revenue for each merchant from this invoice' do
          merchant_1 = create(:random_merchant)
          customer_1 = create(:random_customer)
          invoice_1 = customer_1.invoices.create!(status: 1)
          bulk_discount_1 = merchant_1.bulk_discounts.create!(percentage_discount: 20, quantity_threshold: 10)
          item_1 = merchant_1.items.create!(name: "10 lb bag of flour", description: "10 pounds of it", unit_price: 1000)
          item_2 = merchant_1.items.create!(name: "Hair pins", description: "10 per pack", unit_price: 500)
          invoice_item_1 = InvoiceItem.create!(item: item_1, invoice: invoice_1, unit_price: 1000, quantity: 5, status: 2)
          invoice_item_2 = InvoiceItem.create!(item: item_2, invoice: invoice_1, unit_price: 500, quantity: 5, status: 2)

          expect(invoice_1.discounted_revenue).to eq(7500)
        end

        it 'calculates total discounted revenue for both items if one item qualifies for a discount and one does not' do
          merchant_2 = create(:random_merchant)
          customer_1 = create(:random_customer)
          invoice_2 = customer_1.invoices.create!(status: 1)
          bulk_discount_2 = merchant_2.bulk_discounts.create!(percentage_discount: 20, quantity_threshold: 10)
          item_3 = merchant_2.items.create!(name: "Lemons", description: "Sour", unit_price: 100)
          item_4 = merchant_2.items.create!(name: "Limes", description: "Citrus", unit_price: 100)
          invoice_item_3 = InvoiceItem.create!(item: item_3, invoice: invoice_2, unit_price: 100, quantity: 10, status: 2)
          invoice_item_4 = InvoiceItem.create!(item: item_4, invoice: invoice_2, unit_price: 100, quantity: 5, status: 2)

          expect(invoice_2.discounted_revenue).to eq(1300)
        end

        it 'calculates total discounted revenue for both items when they both qualify for different discounts' do
          merchant_3 = create(:random_merchant)
          customer_1 = create(:random_customer)
          invoice_3 = customer_1.invoices.create!(status: 1)
          bulk_discount_3 = merchant_3.bulk_discounts.create!(percentage_discount: 20, quantity_threshold: 10)
          bulk_discount_4 = merchant_3.bulk_discounts.create!(percentage_discount: 30, quantity_threshold: 15)
          item_5 = merchant_3.items.create!(name: "Rubber earring backs", description: "To hold your earrings in", unit_price: 400)
          item_6 = merchant_3.items.create!(name: "Trash bags", description: "To hold trash", unit_price: 900)
          invoice_item_5 = InvoiceItem.create!(item: item_5, invoice: invoice_3, unit_price: 400, quantity: 12, status: 2)
          invoice_item_6 = InvoiceItem.create!(item: item_6, invoice: invoice_3, unit_price: 900, quantity: 15, status: 2)

          expect(invoice_3.discounted_revenue).to eq(13290)
        end

        it 'calculates total discounted revenue if two items qualify for multiple discounts' do
          merchant_4 = create(:random_merchant)
          customer_1 = create(:random_customer)
          invoice_4 = customer_1.invoices.create!(status: 1)
          bulk_discount_5 = merchant_4.bulk_discounts.create!(percentage_discount: 20, quantity_threshold: 10)
          bulk_discount_6 = merchant_4.bulk_discounts.create!(percentage_discount: 15, quantity_threshold: 15)
          item_7 = merchant_4.items.create!(name: "Twist ties", description: "Twist em", unit_price: 100)
          item_8 = merchant_4.items.create!(name: "Dice", description: "Roll em", unit_price: 200)
          invoice_item_7 = InvoiceItem.create!(item: item_7, invoice: invoice_4, unit_price: 100, quantity: 12, status: 2)
          invoice_item_8 = InvoiceItem.create!(item: item_8, invoice: invoice_4, unit_price: 200, quantity: 15, status: 2)

          expect(invoice_4.discounted_revenue).to eq(3360)
        end

        it 'calculates total discounted revenue if an invoice has multiple merchants and multiple discounts applied' do
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

          expect(invoice_5.discounted_revenue).to eq(12420)
        end

        it 'will return zero if an invoice has no items' do
          invoice_1 = create(:random_invoice)
          expect(invoice_1.discounted_revenue).to eq(0)
        end
      end
    end
  end
end
