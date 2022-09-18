require 'rails_helper'


RSpec.describe 'As a merchant,i click the name of an item from the merchant items index page,' do

  describe "page" do
    let!(:merchant_1) { Merchant.create!(name: "Klein, Rempel and Jones")}
    let!(:item_1) {describtionerchant.create!(name: "Cummings-Thiel")}
    let!(:merchant_3) { Merchant.create!(name: "Williamson Group")}

    let!(:customer_1) { Customer.create!(first_name: 'Matt', last_name: 'Duttko')}
    let!(:customer_2) { Customer.create!(first_name: 'Jon', last_name: 'Duttko')}
    let!(:customer_3) { Customer.create!(first_name: 'Emily', last_name: 'Elder')}
    

    let!(:invoice_1)  { Invoice.create!(customer_id: customer_1.id, status: 'completed') }
    let!(:invoice_2)  { Invoice.create!(customer_id: customer_2.id, status: 'completed') }
    let!(:invoice_3) { Invoice.create!(customer_id: customer_3.id, status: 'completed') }
    

    let!(:item_1) { Item.create!(name: 'Chicken', description: 'poulet', unit_price: 75107, merchant_id: merchant_1.id) }
    let!(:item_2) { Item.create!(name: 'Cow', description: 'vache', unit_price: 75107, merchant_id: merchant_1.id) }
    let!(:item_3) { Item.create!(name: 'Sheep', description: 'mutton', unit_price: 75107, merchant_id: merchant_1.id) }



    let!(:invoice_item_1) { InvoiceItem.create!(item_id: item_1.id, invoice_id: invoice_1.id, quantity: 3, unit_price: 3635, status: 'shipped') }
    let!(:invoice_item_2) { InvoiceItem.create!(item_id: item_2.id, invoice_id: invoice_2.id, quantity: 31, unit_price: 13635, status: 'packaged') }
    let!(:invoice_item_3) { InvoiceItem.create!(item_id: item_3.id, invoice_id: invoice_3.id, quantity: 13, unit_price: 1335, status: 'shipped') }
    
    it 'directs to the merchant index page' do
      
      visit ("merchants/#{merchant_1}/items")
     click_on("#{item_1.name}")
      expect(current_path).to eq("/merchants/merchant_id/item/#{item_1.id}")
    end

    it 'then i am taken to that merchants items show page (/merchants/#{merchant_1.id}/item/item_id)"' do
     expect(current_path).to eq("/merchants/#{merchant_1.id}/item/#{item_1.id}")
    
    end

    it "and i see alll the items attributes including Name/Description/Current Selling price" do
      visit admin_merchants_path

      expect(page).to have_link(item_1.name)
      expect(page).to have_link(item_1.description)
      expect(page).to have_link(item_1.name)
    end
  end
end






