require "rails_helper"


RSpec.describe(Merchant, type: :model) do
  describe("relationships") do
    it { should(have_many(:items)) }
    it { should have_many(:invoice_items).through(:items) }
    it { should have_many(:invoices).through(:invoice_items) }
    it { should have_many(:customers).through(:invoices) }
    it { should have_many(:transactions).through(:invoices) }
    it { should have_many(:bulk_discounts)}
  end

  describe("validations") do
    it { should(validate_presence_of(:name)) }
  end

  describe("instance methods") do
    describe "ready to ship" do
      it("displays the names of all items that have been ordered but not yet shipped") do
        merchant1 = Merchant.create!(      name: "Bob")
        merchant2 = Merchant.create!(      name: "Sally")

        customer1 = Customer.create!(      first_name: "cx first name",       last_name: "cx last name")

        invoice1 = customer1.invoices.create!(      status: 1,       created_at: "2012-03-25 09:53:09")
        invoice2 = customer1.invoices.create!(      status: 1,       created_at: "2012-03-26 09:53:09")
        invoice3 = customer1.invoices.create!(      status: 1,       created_at: "2012-03-27 09:53:09")
        invoice4 = customer1.invoices.create!(      status: 1,       created_at: "2012-03-28 09:53:09")
        invoice5 = customer1.invoices.create!(      status: 1,       created_at: "2012-03-29 09:53:09")
        invoice6 = customer1.invoices.create!(      status: 1,       created_at: "2012-03-29 09:53:09")

        item1 = create(:random_item, merchant_id: merchant1.id)
        item2 = create(:random_item, merchant_id: merchant1.id)
        item3 = create(:random_item, merchant_id: merchant1.id)
        item4 = create(:random_item, merchant_id: merchant1.id)
        item5 = create(:random_item, merchant_id: merchant1.id)
        item6 = create(:random_item, merchant_id: merchant1.id)

        invoice_item1 = InvoiceItem.create!(item_id: item1.id, invoice_id: invoice1.id, unit_price: item1.unit_price, quantity: 2, status: 0)
        invoice_item2 = InvoiceItem.create!(item_id: item2.id, invoice_id: invoice2.id, unit_price: item1.unit_price, quantity: 2, status: 1)
        invoice_item3 = InvoiceItem.create!(item_id: item3.id, invoice_id: invoice3.id, unit_price: item1.unit_price, quantity: 2, status: 0)
        invoice_item4 = InvoiceItem.create!(item_id: item4.id, invoice_id: invoice4.id, unit_price: item1.unit_price, quantity: 2, status: 1)
        invoice_item5 = InvoiceItem.create!(item_id: item5.id, invoice_id: invoice5.id, unit_price: item1.unit_price, quantity: 2, status: 0)
        invoice_item6 = InvoiceItem.create!(item_id: item6.id, invoice_id: invoice6.id, unit_price: item1.unit_price, quantity: 2, status: 2)

        expect(merchant1.ready_to_ship).to(eq([item1, item2, item3, item4, item5]))
        expect(merchant2.ready_to_ship).to eq([])
      end
    end

    describe 'favorite_customers' do
      it 'returns the top 5 customers who have conducted the largest number of successful transactions with my merchant' do
        merchant1 = Merchant.create!(name: "Bob")
        merchant2 = Merchant.create!(name: "Mark")

        customer1 = Customer.create!(first_name: "Jolene", last_name: "Jones")
        customer2 = Customer.create!(first_name: "Jake", last_name: "Jones")
        customer3 = Customer.create!(first_name: "Sally", last_name: "Sue")
        customer4 = Customer.create!(first_name: "Zach", last_name: "Green")
        customer5 = Customer.create!(first_name: "Benedict", last_name: "Cumberbatch")
        customer6 = Customer.create!(first_name: "Marky", last_name: "Mark")
        customer7 = Customer.create!(first_name: "Scarlett", last_name: "JoJo")

        invoice1 = customer1.invoices.create!(status: 1, created_at: "Thurdsday, July 18, 2019 ")
        invoice2 = customer2.invoices.create!(status: 1, created_at: "Wednesday, July 17, 2019 ")
        invoice3 = customer3.invoices.create!(status: 1, created_at: "Wednesday, July 17, 2019 ")
        invoice4 = customer4.invoices.create!(status: 1, created_at: "Wednesday, July 17, 2019 ")
        invoice5 = customer5.invoices.create!(status: 1, created_at: "Wednesday, July 17, 2019 ")
        invoice6 = customer6.invoices.create!(status: 1, created_at: "Wednesday, July 17, 2019 ")
        invoice7 = customer7.invoices.create!(status: 1, created_at: "Wednesday, July 17, 2019 ")

        item2 = merchant1.items.create!(name: "item2", description: "this is item2 description", unit_price: 2)
        item1 = merchant1.items.create!(name: "item1", description: "this is item1 description", unit_price: 1)
        item3 = merchant1.items.create!(name: "item3", description: "this is item3 description", unit_price: 3)
        item4 = merchant1.items.create!(name: "item4", description: "this is item4 description", unit_price: 3)

        invoice_item1 = InvoiceItem.create!(item_id: item1.id, invoice_id: invoice1.id, unit_price: item1.unit_price, quantity: 1, status: 0)
        invoice_item2 = InvoiceItem.create!(item_id: item2.id, invoice_id: invoice1.id, unit_price: item2.unit_price, quantity: 2, status: 0)
        invoice_item3 = InvoiceItem.create!(item_id: item1.id, invoice_id: invoice4.id, unit_price: item3.unit_price, quantity: 3, status: 0)
        invoice_item4 = InvoiceItem.create!(item_id: item3.id, invoice_id: invoice2.id, unit_price: item1.unit_price, quantity: 3, status: 0)
        invoice_item5 = InvoiceItem.create!(item_id: item4.id, invoice_id: invoice3.id, unit_price: item2.unit_price, quantity: 3, status: 0)
        
        transaction1 = Transaction.create!(invoice_id: invoice1.id, credit_card_number: 1234567891023456, credit_card_expiration_date: '', result: 'success' )
        transaction2 = Transaction.create!(invoice_id: invoice2.id, credit_card_number: 9678432137864064, credit_card_expiration_date: '', result: 'success' )
        transaction3 = Transaction.create!(invoice_id: invoice3.id, credit_card_number: 9678432137864064, credit_card_expiration_date: '', result: 'success' )
        transaction4 = Transaction.create!(invoice_id: invoice4.id, credit_card_number: 9678432137864064, credit_card_expiration_date: '', result: 'success' )
        transaction5 = Transaction.create!(invoice_id: invoice5.id, credit_card_number: 9678432137864064, credit_card_expiration_date: '', result: 'success' )

        expect(merchant1.favorite_customers[0].first_name).to eq(customer1.first_name)
        expect(merchant1.favorite_customers[1].first_name).to eq(customer2.first_name)
      end
    end
    
    describe 'total_revenue' do
      it 'returns the total revenue generated from all items on an invoice' do
        merchant1 = Merchant.create!(name: "Bob")
        merchant2 = Merchant.create!(name: "Mark")
        merchant3 = Merchant.create!(name: "Noah")

        customer1 = Customer.create!(first_name: "Jolene", last_name: "Jones")
        customer2 = Customer.create!(first_name: "Jake", last_name: "Jones")
        customer3 = Customer.create!(first_name: "Sally", last_name: "Sue")
        customer4 = Customer.create!(first_name: "Zach", last_name: "Green")
        customer5 = Customer.create!(first_name: "Benedict", last_name: "Cumberbatch")
        customer6 = Customer.create!(first_name: "Marky", last_name: "Mark")
        customer7 = Customer.create!(first_name: "Scarlett", last_name: "JoJo")

        invoice1 = customer1.invoices.create!(status: 1, created_at: "Thurdsday, July 18, 2019 ")
        invoice2 = customer2.invoices.create!(status: 1, created_at: "Wednesday, July 17, 2019 ")
        invoice3 = customer3.invoices.create!(status: 1, created_at: "Wednesday, July 17, 2019 ")
        invoice4 = customer4.invoices.create!(status: 1, created_at: "Wednesday, July 17, 2019 ")
        invoice5 = customer5.invoices.create!(status: 1, created_at: "Wednesday, July 17, 2019 ")
        invoice6 = customer6.invoices.create!(status: 1, created_at: "Wednesday, July 17, 2019 ")
        invoice7 = customer7.invoices.create!(status: 1, created_at: "Wednesday, July 17, 2019 ")

        item2 = merchant1.items.create!(name: "item2", description: "this is item2 description", unit_price: 2)
        item1 = merchant1.items.create!(name: "item1", description: "this is item1 description", unit_price: 1)
        item3 = merchant1.items.create!(name: "item3", description: "this is item3 description", unit_price: 3)
        item4 = merchant2.items.create!(name: "item4", description: "this is item4 description", unit_price: 3)

        invoice_item1 = InvoiceItem.create!(item_id: item1.id, invoice_id: invoice1.id, unit_price: item1.unit_price, quantity: 1, status: 2)
        invoice_item2 = InvoiceItem.create!(item_id: item2.id, invoice_id: invoice1.id, unit_price: item2.unit_price, quantity: 2, status: 2)
        invoice_item3 = InvoiceItem.create!(item_id: item1.id, invoice_id: invoice4.id, unit_price: item3.unit_price, quantity: 3, status: 0)
        invoice_item4 = InvoiceItem.create!(item_id: item3.id, invoice_id: invoice2.id, unit_price: item1.unit_price, quantity: 3, status: 2)
        invoice_item5 = InvoiceItem.create!(item_id: item4.id, invoice_id: invoice3.id, unit_price: item2.unit_price, quantity: 3, status: 2)
        
        transaction1 = Transaction.create!(invoice_id: invoice1.id, credit_card_number: 1234567891023456, credit_card_expiration_date: '', result: 'success' )
        transaction2 = Transaction.create!(invoice_id: invoice2.id, credit_card_number: 9678432137864064, credit_card_expiration_date: '', result: 'success' )
        transaction3 = Transaction.create!(invoice_id: invoice3.id, credit_card_number: 9678432137864064, credit_card_expiration_date: '', result: 'success' )
        transaction4 = Transaction.create!(invoice_id: invoice4.id, credit_card_number: 9678432137864064, credit_card_expiration_date: '', result: 'success' )
        transaction5 = Transaction.create!(invoice_id: invoice5.id, credit_card_number: 9678432137864064, credit_card_expiration_date: '', result: 'success' )
      
        expect(merchant1.total_revenue).to eq(8)
        expect(merchant2.total_revenue).to eq(6)
        expect(merchant3.total_revenue).to eq(0)
      end
    end

    describe 'top_5_items' do
      let!(:merchant_1) {create(:random_merchant)}
      let!(:merchant_2) {create(:random_merchant)}
      let!(:merchant_3) {create(:random_merchant)}
      let!(:merchant_4) {create(:random_merchant)}
      let!(:merchant_5) {create(:random_merchant)}
      let!(:merchant_6) {create(:random_merchant)}
      let!(:merchant_7) {create(:random_merchant)}

      let!(:item_1) {create(:random_item, merchant_id: merchant_1.id)}
      let!(:item_2) {create(:random_item, merchant_id: merchant_1.id)}
      let!(:item_3) {create(:random_item, merchant_id: merchant_1.id)}
      let!(:item_4) {create(:random_item, merchant_id: merchant_1.id)}
      let!(:item_5) {create(:random_item, merchant_id: merchant_1.id)}
      let!(:item_6) {create(:random_item, merchant_id: merchant_1.id)}
      let!(:item_7) {create(:random_item, merchant_id: merchant_1.id)}
      let!(:item_8) {create(:random_item, merchant_id: merchant_1.id)}
      let!(:item_9) {create(:random_item, merchant_id: merchant_1.id)}
      let!(:item_10) {create(:random_item, merchant_id: merchant_2.id)}
     
      let!(:item_11) {create(:random_item, merchant_id: merchant_3.id)}
      let!(:item_12) {create(:random_item, merchant_id: merchant_3.id)}
      let!(:item_13) {create(:random_item, merchant_id: merchant_4.id)}
      let!(:item_14) {create(:random_item, merchant_id: merchant_5.id)}
      let!(:item_15) {create(:random_item, merchant_id: merchant_6.id)}
      let!(:item_16) {create(:random_item, merchant_id: merchant_2.id)}
      let!(:item_17) {create(:random_item, merchant_id: merchant_7.id)}

      let!(:customer_1) {create(:random_customer)}
      let!(:customer_2) {create(:random_customer)}
      let!(:customer_3) {create(:random_customer)}
      let!(:customer_4) {create(:random_customer)}

      let!(:invoice_1) {Invoice.create!(customer_id: customer_1.id, created_at: Time.new(2019, 8, 2, 8, 11, 9), status: 'completed')}
      let!(:invoice_2) {Invoice.create!(customer_id: customer_2.id, created_at: Time.new(2018, 6, 3, 3, 11, 9), status: 'completed')}
      let!(:invoice_3) {Invoice.create!(customer_id: customer_3.id, created_at: Time.new(2017, 9, 3, 1, 11, 9), status: 'cancelled')}
      let!(:invoice_4) {Invoice.create!(customer_id: customer_4.id, created_at: Time.new(2019, 3, 3, 12, 11, 9), status: 'completed')}
      let!(:invoice_5) {Invoice.create!(customer_id: customer_4.id, created_at: Time.new(2018, 2, 3, 12, 11, 9), status: 'completed')}
      let!(:invoice_6) {Invoice.create!(customer_id: customer_4.id, created_at: Time.new(2016, 9, 3, 9, 11, 9), status: 'completed')}
      
      let!(:invoice_7) {Invoice.create!(customer_id: customer_3.id, created_at: Time.new(2016, 9, 3, 9, 11, 9), status: 'completed')}
      let!(:invoice_8) {Invoice.create!(customer_id: customer_3.id, created_at: Time.new(2016, 9, 3, 9, 11, 9), status: 'completed')}
      let!(:invoice_9) {Invoice.create!(customer_id: customer_3.id, created_at: Time.new(2016, 9, 3, 9, 11, 9), status: 'completed')}
      let!(:invoice_10) {Invoice.create!(customer_id: customer_3.id, created_at: Time.new(2016, 9, 3, 9, 11, 9), status: 'completed')}


      let!(:transaction_1) {Transaction.create!(invoice_id: invoice_1.id, credit_card_number: 4654405418249632, credit_card_expiration_date: '', result: 'failed')}
      let!(:transaction_2) {Transaction.create!(invoice_id: invoice_1.id, credit_card_number: 4654405418249632, credit_card_expiration_date: '', result: 'failed')}
      let!(:transaction_3) {Transaction.create!(invoice_id: invoice_2.id, credit_card_number: 4654405418249632, credit_card_expiration_date: '', result: 'success')}
      let!(:transaction_4) {Transaction.create!(invoice_id: invoice_2.id, credit_card_number: 4654405418249632, credit_card_expiration_date: '', result: 'failed')}
      let!(:transaction_5) {Transaction.create!(invoice_id: invoice_3.id, credit_card_number: 4654405418249632, credit_card_expiration_date: '', result: 'failed')}
      let!(:transaction_6) {Transaction.create!(invoice_id: invoice_3.id, credit_card_number: 4654405418249632, credit_card_expiration_date: '', result: 'success')}
      let!(:transaction_7) {Transaction.create!(invoice_id: invoice_4.id, credit_card_number: 4654405418249632, credit_card_expiration_date: '', result: 'success')}
      let!(:transaction_8) {Transaction.create!(invoice_id: invoice_5.id, credit_card_number: 4654405418249632, credit_card_expiration_date: '', result: 'success')}

      let!(:invoice_item_1) { InvoiceItem.create!(item_id: item_1.id, invoice_id: invoice_1.id, quantity: 3, unit_price: 2000, status: 'shipped', created_at: Time.new(2020, 9, 2, 10, 11, 9)) } 
      let!(:invoice_item_2) { InvoiceItem.create!(item_id: item_2.id, invoice_id: invoice_1.id, quantity: 3, unit_price: 2000, status: 'packaged', created_at: Time.new(2020, 9, 2, 10, 11, 9)) }
      let!(:invoice_item_3) { InvoiceItem.create!(item_id: item_3.id, invoice_id: invoice_2.id, quantity: 3, unit_price: 300, status: 'shipped', created_at: Time.new(2021, 9, 1, 12, 11, 9)) }
      let!(:invoice_item_4) { InvoiceItem.create!(item_id: item_4.id, invoice_id: invoice_2.id, quantity: 3, unit_price: 400, status: 'pending', created_at: Time.new(2021, 9, 9, 19, 11, 9)) }
      let!(:invoice_item_5) { InvoiceItem.create!(item_id: item_5.id, invoice_id: invoice_4.id, quantity: 3, unit_price: 500, status: 'pending', created_at: Time.new(2021, 9, 1, 10, 11, 9)) }
      let!(:invoice_item_6) { InvoiceItem.create!(item_id: item_6.id, invoice_id: invoice_3.id, quantity: 3, unit_price: 600, status: 'pending', created_at: Time.new(2020, 9, 1, 11, 11, 9)) }
      let!(:invoice_item_7) { InvoiceItem.create!(item_id: item_7.id, invoice_id: invoice_3.id, quantity: 3, unit_price: 700, status: 'pending', created_at: Time.new(2010, 9, 9, 19, 11, 9)) }
      let!(:invoice_item_8) { InvoiceItem.create!(item_id: item_8.id, invoice_id: invoice_4.id, quantity: 3, unit_price: 800, status: 'shipped', created_at: Time.new(2011, 9, 1, 14, 11, 9)) }
      let!(:invoice_item_9) { InvoiceItem.create!(item_id: item_9.id, invoice_id: invoice_5.id, quantity: 3, unit_price: 900, status: 'shipped', created_at: Time.new(2013, 9, 4, 12, 11, 9)) }
      let!(:invoice_item_10) { InvoiceItem.create!(item_id: item_10.id, invoice_id: invoice_5.id, quantity: 3, unit_price: 1000, status: 'shipped', created_at: Time.new(2020, 9, 3, 12, 11, 9)) }
      let!(:invoice_item_11) { InvoiceItem.create!(item_id: item_11.id, invoice_id: invoice_5.id, quantity: 3, unit_price: 1000, status: 'pending', created_at: Time.new(2020, 9, 3, 12, 11, 9)) }
      let!(:invoice_item_12) { InvoiceItem.create!(item_id: item_12.id, invoice_id: invoice_5.id, quantity: 3, unit_price: 1000, status: 'pending', created_at: Time.new(2020, 9, 3, 12, 11, 9)) }
      let!(:invoice_item_13) { InvoiceItem.create!(item_id: item_13.id, invoice_id: invoice_5.id, quantity: 3, unit_price: 1000, status: 'pending', created_at: Time.new(2020, 9, 3, 12, 11, 9)) }
      let!(:invoice_item_14) { InvoiceItem.create!(item_id: item_14.id, invoice_id: invoice_5.id, quantity: 3, unit_price: 1000, status: 'pending', created_at: Time.new(2020, 9, 3, 12, 11, 9)) }
      let!(:invoice_item_15) { InvoiceItem.create!(item_id: item_15.id, invoice_id: invoice_5.id, quantity: 3, unit_price: 1000, status: 'pending', created_at: Time.new(2020, 9, 3, 12, 11, 9)) }
      let!(:invoice_item_16) { InvoiceItem.create!(item_id: item_16.id, invoice_id: invoice_5.id, quantity: 3, unit_price: 1000, status: 'pending', created_at: Time.new(2020, 9, 3, 12, 11, 9)) }
      let!(:invoice_item_17) { InvoiceItem.create!(item_id: item_17.id, invoice_id: invoice_5.id, quantity: 3, unit_price: 1000, status: 'pending', created_at: Time.new(2020, 9, 3, 12, 11, 9)) }

      it 'returns the 5 most popular items for a merchant by total revenue' do
        expect(merchant_1.top_5_items).to eq([item_9, item_8, item_7, item_6, item_5])
      end

      it 'returns the total revenue generated for each item' do
        expect(merchant_1.top_5_items[0].revenue).to eq(2700)
        expect(merchant_1.top_5_items[2].revenue).to eq(2100)
        expect(merchant_1.top_5_items[3].revenue).to eq(1800)
      end

      describe "best_day" do
        it "returns the best day of sales for a given merchant" do
          expect(merchant_1.top_day).to eq (Time.new(2019, 03, 03)).to_date
          expect(merchant_2.top_day).to eq (Time.new(2018, 02, 03)).to_date
        end
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

          expect(merchant_1.discount).to eq(0)
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

          expect(merchant_2.discount).to eq(200)
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
          #item 5 should be discounted at 20, item 6 should be discounted at 30
          expect(merchant_3.discount).to eq(5010)
          
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
      
          expect(merchant_4.discount).to eq(840)
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

          expect(merchant_5.discount).to eq(2730)
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

          expect(merchant_1.discounted_revenue).to eq(7500)
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

          expect(merchant_2.discounted_revenue).to eq(1300)
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

          expect(merchant_3.discounted_revenue).to eq(13290)
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

          expect(merchant_4.discounted_revenue).to eq(3360)
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

          expect(merchant_5.discounted_revenue).to eq(7170)
        end

        it 'will return zero if a merchant has no invoices' do
          merchant_1 = create(:random_merchant)

          expect(merchant_1.discounted_revenue).to eq(0)
        end
      end
    end
  end

  describe 'class methods' do
    let!(:merchant_1) {create(:random_merchant)}
    let!(:merchant_2) {create(:random_merchant)}
    let!(:merchant_3) {create(:random_merchant)}
    let!(:merchant_4) {create(:random_merchant)}
    let!(:merchant_5) {create(:random_merchant)}
    let!(:merchant_6) {create(:random_merchant)}
    let!(:merchant_7) {create(:random_merchant)}

    let!(:item_1) {create(:random_item, merchant_id: merchant_1.id)}
    let!(:item_2) {create(:random_item, merchant_id: merchant_1.id)}
    let!(:item_3) {create(:random_item, merchant_id: merchant_1.id)}
    let!(:item_4) {create(:random_item, merchant_id: merchant_1.id)}
    let!(:item_5) {create(:random_item, merchant_id: merchant_1.id)}
    let!(:item_6) {create(:random_item, merchant_id: merchant_1.id)}
    let!(:item_7) {create(:random_item, merchant_id: merchant_1.id)}
    let!(:item_8) {create(:random_item, merchant_id: merchant_1.id)}
    let!(:item_9) {create(:random_item, merchant_id: merchant_1.id)}
    let!(:item_10) {create(:random_item, merchant_id: merchant_2.id)}
    
    let!(:item_11) {create(:random_item, merchant_id: merchant_3.id)}
    let!(:item_12) {create(:random_item, merchant_id: merchant_3.id)}
    let!(:item_13) {create(:random_item, merchant_id: merchant_4.id)}
    let!(:item_14) {create(:random_item, merchant_id: merchant_5.id)}
    let!(:item_15) {create(:random_item, merchant_id: merchant_6.id)}
    let!(:item_16) {create(:random_item, merchant_id: merchant_2.id)}
    let!(:item_17) {create(:random_item, merchant_id: merchant_7.id)}

    let!(:customer_1) {create(:random_customer)}
    let!(:customer_2) {create(:random_customer)}
    let!(:customer_3) {create(:random_customer)}
    let!(:customer_4) {create(:random_customer)}

    let!(:invoice_1) {Invoice.create!(customer_id: customer_1.id, created_at: Time.new(2019, 8, 2, 8, 11, 9), status: 'completed')}
    let!(:invoice_2) {Invoice.create!(customer_id: customer_2.id, created_at: Time.new(2018, 6, 3, 3, 11, 9), status: 'completed')}
    let!(:invoice_3) {Invoice.create!(customer_id: customer_3.id, created_at: Time.new(2017, 9, 3, 1, 11, 9), status: 'cancelled')}
    let!(:invoice_4) {Invoice.create!(customer_id: customer_4.id, created_at: Time.new(2019, 3, 3, 12, 11, 9), status: 'completed')}
    let!(:invoice_5) {Invoice.create!(customer_id: customer_4.id, created_at: Time.new(2018, 2, 3, 12, 11, 9), status: 'completed')}
    let!(:invoice_6) {Invoice.create!(customer_id: customer_4.id, created_at: Time.new(2016, 9, 3, 9, 11, 9), status: 'completed')}
    
    let!(:invoice_7) {Invoice.create!(customer_id: customer_3.id, created_at: Time.new(2016, 9, 3, 9, 11, 9), status: 'completed')}
    let!(:invoice_8) {Invoice.create!(customer_id: customer_3.id, created_at: Time.new(2016, 9, 3, 9, 11, 9), status: 'completed')}
    let!(:invoice_9) {Invoice.create!(customer_id: customer_3.id, created_at: Time.new(2016, 9, 3, 9, 11, 9), status: 'completed')}
    let!(:invoice_10) {Invoice.create!(customer_id: customer_3.id, created_at: Time.new(2016, 9, 3, 9, 11, 9), status: 'completed')}


    let!(:transaction_1) {Transaction.create!(invoice_id: invoice_1.id, credit_card_number: 4654405418249632, credit_card_expiration_date: '', result: 'failed')}
    let!(:transaction_2) {Transaction.create!(invoice_id: invoice_1.id, credit_card_number: 4654405418249632, credit_card_expiration_date: '', result: 'failed')}
    let!(:transaction_3) {Transaction.create!(invoice_id: invoice_2.id, credit_card_number: 4654405418249632, credit_card_expiration_date: '', result: 'success')}
    let!(:transaction_4) {Transaction.create!(invoice_id: invoice_2.id, credit_card_number: 4654405418249632, credit_card_expiration_date: '', result: 'failed')}
    let!(:transaction_5) {Transaction.create!(invoice_id: invoice_3.id, credit_card_number: 4654405418249632, credit_card_expiration_date: '', result: 'failed')}
    let!(:transaction_6) {Transaction.create!(invoice_id: invoice_3.id, credit_card_number: 4654405418249632, credit_card_expiration_date: '', result: 'success')}
    let!(:transaction_7) {Transaction.create!(invoice_id: invoice_4.id, credit_card_number: 4654405418249632, credit_card_expiration_date: '', result: 'success')}
    let!(:transaction_8) {Transaction.create!(invoice_id: invoice_5.id, credit_card_number: 4654405418249632, credit_card_expiration_date: '', result: 'success')}

    let!(:invoice_item_1) { InvoiceItem.create!(item_id: item_1.id, invoice_id: invoice_1.id, quantity: 3, unit_price: 2000, status: 'shipped', created_at: Time.new(2020, 9, 2, 10, 11, 9)) } 
    let!(:invoice_item_2) { InvoiceItem.create!(item_id: item_2.id, invoice_id: invoice_1.id, quantity: 3, unit_price: 2000, status: 'packaged', created_at: Time.new(2020, 9, 2, 10, 11, 9)) }
    let!(:invoice_item_3) { InvoiceItem.create!(item_id: item_3.id, invoice_id: invoice_2.id, quantity: 3, unit_price: 300, status: 'shipped', created_at: Time.new(2021, 9, 1, 12, 11, 9)) }
    let!(:invoice_item_4) { InvoiceItem.create!(item_id: item_4.id, invoice_id: invoice_2.id, quantity: 3, unit_price: 400, status: 'pending', created_at: Time.new(2021, 9, 9, 19, 11, 9)) }
    let!(:invoice_item_5) { InvoiceItem.create!(item_id: item_5.id, invoice_id: invoice_4.id, quantity: 3, unit_price: 500, status: 'pending', created_at: Time.new(2021, 9, 1, 10, 11, 9)) }
    let!(:invoice_item_6) { InvoiceItem.create!(item_id: item_6.id, invoice_id: invoice_3.id, quantity: 3, unit_price: 600, status: 'pending', created_at: Time.new(2020, 9, 1, 11, 11, 9)) }
    let!(:invoice_item_7) { InvoiceItem.create!(item_id: item_7.id, invoice_id: invoice_3.id, quantity: 3, unit_price: 700, status: 'pending', created_at: Time.new(2010, 9, 9, 19, 11, 9)) }
    let!(:invoice_item_8) { InvoiceItem.create!(item_id: item_8.id, invoice_id: invoice_4.id, quantity: 3, unit_price: 800, status: 'shipped', created_at: Time.new(2011, 9, 1, 14, 11, 9)) }
    let!(:invoice_item_9) { InvoiceItem.create!(item_id: item_9.id, invoice_id: invoice_5.id, quantity: 3, unit_price: 900, status: 'shipped', created_at: Time.new(2013, 9, 4, 12, 11, 9)) }
    let!(:invoice_item_10) { InvoiceItem.create!(item_id: item_10.id, invoice_id: invoice_5.id, quantity: 3, unit_price: 1000, status: 'shipped', created_at: Time.new(2020, 9, 3, 12, 11, 9)) }
    let!(:invoice_item_11) { InvoiceItem.create!(item_id: item_11.id, invoice_id: invoice_5.id, quantity: 3, unit_price: 1000, status: 'pending', created_at: Time.new(2020, 9, 3, 12, 11, 9)) }
    let!(:invoice_item_12) { InvoiceItem.create!(item_id: item_12.id, invoice_id: invoice_5.id, quantity: 3, unit_price: 1000, status: 'pending', created_at: Time.new(2020, 9, 3, 12, 11, 9)) }
    let!(:invoice_item_13) { InvoiceItem.create!(item_id: item_13.id, invoice_id: invoice_5.id, quantity: 3, unit_price: 1000, status: 'pending', created_at: Time.new(2020, 9, 3, 12, 11, 9)) }
    let!(:invoice_item_14) { InvoiceItem.create!(item_id: item_14.id, invoice_id: invoice_5.id, quantity: 3, unit_price: 1000, status: 'pending', created_at: Time.new(2020, 9, 3, 12, 11, 9)) }
    let!(:invoice_item_15) { InvoiceItem.create!(item_id: item_15.id, invoice_id: invoice_5.id, quantity: 3, unit_price: 1000, status: 'pending', created_at: Time.new(2020, 9, 3, 12, 11, 9)) }
    let!(:invoice_item_16) { InvoiceItem.create!(item_id: item_16.id, invoice_id: invoice_5.id, quantity: 3, unit_price: 1000, status: 'pending', created_at: Time.new(2020, 9, 3, 12, 11, 9)) }
    let!(:invoice_item_17) { InvoiceItem.create!(item_id: item_17.id, invoice_id: invoice_5.id, quantity: 3, unit_price: 1000, status: 'pending', created_at: Time.new(2020, 9, 3, 12, 11, 9)) }

    describe "#top_5_revenue" do
      it "returns the 5 merchants with the highest total revenue" do
        expect(Merchant.top_5_revenue[0].name).to eq merchant_1.name
        expect(Merchant.top_5_revenue[1].name).to eq merchant_2.name
        expect(Merchant.top_5_revenue).to eq [merchant_1, merchant_2, merchant_3, merchant_4, merchant_5]
      end
    end
  end
end



