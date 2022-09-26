require 'rails_helper'

RSpec.describe 'As an admin, when I visit the admin merchant index' do

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

  describe "page" do
    before(:each) do
      visit admin_merchants_path
    end

    it 'directs to the admin merchant index page' do
      expect(current_path).to eq("/admin/merchants")
    end

    it 'displays the name of each merchant in the system' do
      expect(page).to have_content(merchant_1.name)
      expect(page).to have_content(merchant_2.name)
      expect(page).to have_content(merchant_3.name)
    end

    it 'has links to the show page for each merchant' do
      expect(page).to have_link(merchant_1.name)
      expect(page).to have_link(merchant_2.name)
      expect(page).to have_link(merchant_3.name)
    end
  end

  describe ":Creating New Merchant:" do
    it 'has a link to create a new merchant' do
      visit admin_merchants_path

      expect(page).to have_button("Create New Merchant")
    end

    it 'when I click the button, I am taken to a form with the attributes for a new merchant' do
      visit admin_merchants_path
      click_button("Create New Merchant")

      expect(current_path).to eq new_admin_merchant_path
      expect(page).to have_field(:name)
    end
  end

  describe ":Enable/disable merchant:" do
    it 'has a button that says enable if the merchant is disabled, and vice versa' do
      visit admin_merchants_path

      expect(page).to have_button("Disable #{merchant_1.name}")
      expect(merchant_1.enabled).to eq true

      click_button("Disable #{merchant_2.name}")

      expect(page).to have_button("Enable #{merchant_2.name}")
    end

    it 'redirects me to the merchant index page' do
      visit admin_merchants_path

      expect(page).to have_button("Disable #{merchant_1.name}")
      expect(merchant_1.enabled).to eq true

      click_button("Disable #{merchant_2.name}")

      expect(page).to have_button("Enable #{merchant_2.name}")
      expect(current_path).to eq(admin_merchants_path)
    end

    it 'the button changes the status of an enabled merchant to disabled' do
      visit admin_merchants_path

      click_button("Disable #{merchant_1.name}")

      expect(page).to have_button("Enable #{merchant_1.name}")
    end
  end

  describe ":top 5 merchant display:" do
    it "displays the 5 merchants with the highest total revenue" do
      visit admin_merchants_path
      
      within "#top-merchants" do
        expect(page).to have_content(merchant_1.name)
        expect(page).to have_content(merchant_1.top_day.strftime('%A, %B %d, %Y'))
        expect(page).to have_content(merchant_2.name)
        expect(page).to have_content(merchant_2.top_day.strftime('%A, %B %d, %Y'))
        expect(page).to have_content(merchant_3.name)
        expect(page).to have_content(merchant_3.top_day.strftime('%A, %B %d, %Y'))
        expect(page).to have_content(merchant_4.name)
        expect(page).to have_content(merchant_4.top_day.strftime('%A, %B %d, %Y'))
        expect(page).to have_content(merchant_5.name)
        expect(page).to have_content(merchant_5.top_day.strftime('%A, %B %d, %Y'))
      end
    end
  end
end






