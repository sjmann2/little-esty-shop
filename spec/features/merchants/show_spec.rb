require "rails_helper"


RSpec.describe("1.the merchant dashboard") do
  describe("1.visit my merchant dashboard") do
    it("I see the name of my merchant") do
      merchant1 = Merchant.create!(      name: "Bob")
      visit("/merchants/#{merchant1.id}/dashboard")
      expect(page).to(have_content("#{merchant1.name}"))
    end

    it("I see link to my merchant items and invoices index") do
      merchant1 = Merchant.create!(      name: "Bob")
      visit("/merchants/#{merchant1.id}/dashboard")
      expect(page).to(have_link("Items Index"))
      expect(page).to(have_link("Invoices Index"))
    end

    it("I can click on items index link and be directed") do
      merchant1 = Merchant.create!(      name: "Bob")
      visit("/merchants/#{merchant1.id}/dashboard")
      click_link("Items Index")
      expect(current_path).to(eq("/merchants/#{merchant1.id}/items"))
    end

    it("I can click the invoices index link and be directed") do
      merchant1 = Merchant.create!(      name: "Bob")
      visit("/merchants/#{merchant1.id}/dashboard")
      click_link("Invoices Index")
      expect(current_path).to(eq("/merchants/#{merchant1.id}/invoices"))
    end
  end

  #Merchant Dashboard Items Ready to Ship
  #As a merchant
  #When I visit my merchant dashboard
  #Then I see a section for "Items Ready to Ship"
  #In that section I see a list of the names of all of my items that
  #have been ordered and have not yet been shipped,
  #And next to each Item I see the id of the invoice that ordered my item
  #And each invoice id is a link to my merchant's invoice show page
  describe("4.visit my merchant dashboard") do
    it("I see a section for 'Items Ready to Ship'") do
      merchant1 = Merchant.create!(      name: "Bob")
      customer1 = Customer.create!(      first_name: "cx first name",       last_name: "cx last name")
      invoice1 = customer1.invoices.create!(      status: 1,       created_at: "2021-09-14 09:00:01")
      invoice2 = customer1.invoices.create!(      status: 1,       created_at: "2021-09-14 09:00:02")
      invoice3 = customer1.invoices.create!(      status: 1,       created_at: "2021-09-14 09:00:03")
      item1 = merchant1.items.create!(      name: "item1",       description: "this is item1 description",       unit_price: 1)
      item2 = merchant1.items.create!(      name: "item2",       description: "this is item2 description",       unit_price: 2)
      item3 = merchant1.items.create!(      name: "item3",       description: "this is item3 description",       unit_price: 3)
      invoice_item1 = InvoiceItem.create!(      item_id: item1.id,       invoice_id: invoice1.id,       unit_price: item1.unit_price,       quantity: 1,       status: 0)
      invoice_item2 = InvoiceItem.create!(      item_id: item2.id,       invoice_id: invoice2.id,       unit_price: item2.unit_price,       quantity: 2,       status: 0)
      invoice_item3 = InvoiceItem.create!(      item_id: item3.id,       invoice_id: invoice3.id,       unit_price: item3.unit_price,       quantity: 3,       status: 0)

      #transaction1 = invoice1.transactions.create!(      result: "success")
      visit("/merchants/#{merchant1.id}/dashboard")
      expect(page).to(have_content("Items Ready to Ship"))
      expect(page).to(have_content("#{item1.name}"))
      expect(page).to(have_content("#{item2.name}"))
      expect(page).to(have_content("#{item3.name}"))
    end
  end

  describe("4.And next to each Item I see the id of the invoice that ordered my item") do
    it("And each invoice id is a link to my merchant's invoice show page") do
      merchant1 = Merchant.create!(      name: "Bob")
      customer1 = Customer.create!(      first_name: "cx first name",       last_name: "cx last name")
      invoice1 = customer1.invoices.create!(      status: 1,       created_at: "2021-09-14 09:00:01")
      invoice2 = customer1.invoices.create!(      status: 1,       created_at: "2021-09-14 09:00:02")
      invoice3 = customer1.invoices.create!(      status: 1,       created_at: "2021-09-14 09:00:03")
      item1 = merchant1.items.create!(      name: "item1",       description: "this is item1 description",       unit_price: 1)
      item2 = merchant1.items.create!(      name: "item2",       description: "this is item2 description",       unit_price: 2)
      item3 = merchant1.items.create!(      name: "item3",       description: "this is item3 description",       unit_price: 3)
      invoice_item1 = InvoiceItem.create!(      item_id: item1.id,       invoice_id: invoice1.id,       unit_price: item1.unit_price,       quantity: 1,       status: 0)
      invoice_item2 = InvoiceItem.create!(      item_id: item2.id,       invoice_id: invoice2.id,       unit_price: item2.unit_price,       quantity: 2,       status: 0)
      invoice_item3 = InvoiceItem.create!(      item_id: item3.id,       invoice_id: invoice3.id,       unit_price: item3.unit_price,       quantity: 3,       status: 0)
      visit("/merchants/#{merchant1.id}/dashboard")
      save_and_open_page
      click_link("#{invoice_item1.invoice_id}")
      expect(current_path).to(eq("/merchants/#{merchant1.id}/invoices/#{invoice_item1.invoice_id}"))
    end
  end
end
