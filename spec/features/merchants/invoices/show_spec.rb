require "rails_helper"

RSpec.describe "the merchant invoices show"  do
  describe 'I see all information related to that invoice' do
    it 'can display the invoice id' do
      merchant1 = Merchant.create!(name: "Bob")
      customer1 = Customer.create!(first_name: "Jolene", last_name: "Jones")
      invoice_1 = customer1.invoices.create!(status: 1, created_at: "2021-09-14 09:00:01")

      visit merchant_invoice_path(merchant1, invoice_1)
      expect(page).to have_content("Invoice: #{invoice_1.id}")
    end

    it 'can display the invoice status' do
      merchant1 = Merchant.create!(name: "Bob")
      customer1 = Customer.create!(first_name: "Jolene", last_name: "Jones")
      invoice_1 = customer1.invoices.create!(status: 1, created_at: "2021-09-14 09:00:01")

      visit merchant_invoice_path(merchant1, invoice_1)
      expect(page).to have_content("Invoice Status:")
    end

    it 'can display the date format for its creation date' do
      merchant1 = Merchant.create!(name: "Bob")
      customer1 = Customer.create!(first_name: "Jolene", last_name: "Jones")
      invoice_1 = customer1.invoices.create!(status: 1, created_at: "2021-09-14 09:00:01")
      
      visit merchant_invoice_path(merchant1, invoice_1)
      
      expect(page).to have_content("Created: #{invoice_1.created_at.strftime("%A, %B %d, %Y")}")
    end

    it 'can display the customers first and last name' do
      merchant1 = Merchant.create!(name: "Bob")
      customer1 = Customer.create!(first_name: "Jolene", last_name: "Jones")
      invoice_1 = customer1.invoices.create!(status: 1, created_at: "2021-09-14 09:00:01")

      visit merchant_invoice_path(merchant1, invoice_1)
      expect(page).to have_content("Customer: #{customer1.first_name} #{customer1.last_name}")
    end

    describe 'I can see the item information within that invoice' do
      it 'can display the item name' do
        merchant1 = Merchant.create!(name: "Bob")
        merchant2 = Merchant.create!(name: "Mark")
        customer1 = Customer.create!(first_name: "Jolene", last_name: "Jones")
        invoice_1 = customer1.invoices.create!(status: 1, created_at: "2021-09-14 09:00:01")
        item1 = merchant1.items.create!(name: "item1", description: "this is item1 description", unit_price: 1)
        item2 = merchant1.items.create!(name: "item2", description: "this is item2 description", unit_price: 2)
        item3 = merchant1.items.create!(name: "item3", description: "this is item3 description", unit_price: 3)
        item4 = merchant2.items.create!(name: "item4", description: "this is item4 description", unit_price: 3)
        invoice_item1 = InvoiceItem.create!(item_id: item1.id, invoice_id: invoice_1.id, unit_price: item1.unit_price, quantity: 1, status: 0)
        invoice_item2 = InvoiceItem.create!(item_id: item2.id, invoice_id: invoice_1.id, unit_price: item2.unit_price, quantity: 1, status: 0)
        invoice_item3 = InvoiceItem.create!(item_id: item3.id, invoice_id: invoice_1.id, unit_price: item3.unit_price, quantity: 1, status: 0)

        visit merchant_invoice_path(merchant1, invoice_1)

        expect(page).to have_content("#{item1.name}")
        expect(page).to have_content("#{item2.name}")
        expect(page).to have_content("#{item3.name}")
        expect(page).to_not have_content("#{item4.name}")
      end
     
      it 'can display the quantity of that item' do
        merchant1 = Merchant.create!(name: "Bob")
        merchant2 = Merchant.create!(name: "Mark")
        customer1 = Customer.create!(first_name: "Jolene", last_name: "Jones")
        invoice_1 = customer1.invoices.create!(status: 1, created_at: "2021-09-14 09:00:01")
        item1 = merchant1.items.create!(name: "item1", description: "this is item1 description", unit_price: 1)
        item2 = merchant1.items.create!(name: "item2", description: "this is item2 description", unit_price: 2)
        item3 = merchant1.items.create!(name: "item3", description: "this is item3 description", unit_price: 3)
        item4 = merchant2.items.create!(name: "item4", description: "this is item4 description", unit_price: 3)
        invoice_item1 = InvoiceItem.create!(item_id: item1.id, invoice_id: invoice_1.id, unit_price: item1.unit_price, quantity: 1, status: 0)
        invoice_item2 = InvoiceItem.create!(item_id: item2.id, invoice_id: invoice_1.id, unit_price: item2.unit_price, quantity: 1, status: 0)
        invoice_item3 = InvoiceItem.create!(item_id: item3.id, invoice_id: invoice_1.id, unit_price: item3.unit_price, quantity: 1, status: 0)
        

        visit merchant_invoice_path(merchant1, invoice_1)

        expect(page).to have_content("#{invoice_item1.quantity}")
        expect(page).to have_content("#{invoice_item2.quantity}")
        expect(page).to have_content("#{invoice_item3.quantity}")
      end

      it 'can display the price that item sold for' do
        merchant1 = Merchant.create!(name: "Bob")
        merchant2 = Merchant.create!(name: "Mark")
        customer1 = Customer.create!(first_name: "Jolene", last_name: "Jones")
        invoice_1 = customer1.invoices.create!(status: 1, created_at: "2021-09-14 09:00:01")
        item1 = merchant1.items.create!(name: "item1", description: "this is item1 description", unit_price: 1)
        item2 = merchant1.items.create!(name: "item2", description: "this is item2 description", unit_price: 2)
        item3 = merchant1.items.create!(name: "item3", description: "this is item3 description", unit_price: 3)
        item4 = merchant2.items.create!(name: "item4", description: "this is item4 description", unit_price: 3)
        invoice_item1 = InvoiceItem.create!(item_id: item1.id, invoice_id: invoice_1.id, unit_price: item1.unit_price, quantity: 1, status: 0)
        invoice_item2 = InvoiceItem.create!(item_id: item2.id, invoice_id: invoice_1.id, unit_price: item2.unit_price, quantity: 1, status: 0)
        invoice_item3 = InvoiceItem.create!(item_id: item3.id, invoice_id: invoice_1.id, unit_price: item3.unit_price, quantity: 1, status: 0)

        visit merchant_invoice_path(merchant1, invoice_1)
        
        expect(page).to have_content("#{item1.unit_price}")
        expect(page).to have_content("#{item2.unit_price}")
        expect(page).to have_content("#{item3.unit_price}")
      end

      it 'can display the invoice item status' do
        merchant1 = Merchant.create!(name: "Bob")
        merchant2 = Merchant.create!(name: "Mark")
        customer1 = Customer.create!(first_name: "Jolene", last_name: "Jones")
        invoice_1 = customer1.invoices.create!(status: 1, created_at: "2021-09-14 09:00:01")
        item1 = merchant1.items.create!(name: "item1", description: "this is item1 description", unit_price: 1)
        item2 = merchant1.items.create!(name: "item2", description: "this is item2 description", unit_price: 2)
        item3 = merchant1.items.create!(name: "item3", description: "this is item3 description", unit_price: 3)
        item4 = merchant2.items.create!(name: "item4", description: "this is item4 description", unit_price: 3)
        invoice_item1 = InvoiceItem.create!(item_id: item1.id, invoice_id: invoice_1.id, unit_price: item1.unit_price, quantity: 1, status: 0)
        invoice_item2 = InvoiceItem.create!(item_id: item2.id, invoice_id: invoice_1.id, unit_price: item2.unit_price, quantity: 1, status: 0)
        invoice_item3 = InvoiceItem.create!(item_id: item3.id, invoice_id: invoice_1.id, unit_price: item3.unit_price, quantity: 1, status: 0)  

        visit merchant_invoice_path(merchant1, invoice_1)
        
        expect(page).to have_content("#{invoice_item1.status}")
        expect(page).to have_content("#{invoice_item2.status}")
        expect(page).to have_content("#{invoice_item3.status}")
      end
    end

    describe 'I can see the total revenue' do
      it 'displays total revenue from all merchant items within an invoice' do
        merchant_1 = create(:random_merchant)
        customer_1 = create(:random_customer)
        invoice_1 = customer_1.invoices.create!(status: 1)
        item_1 = merchant_1.items.create!(name: "Lemons", description: "Sour", unit_price: 100)
        item_2 = merchant_1.items.create!(name: "Limes", description: "Citrus", unit_price: 100)
        invoice_item_1 = InvoiceItem.create!(item: item_1, invoice: invoice_1, unit_price: 100, quantity: 10, status: 2)
        invoice_item_2 = InvoiceItem.create!(item: item_2, invoice: invoice_1, unit_price: 100, quantity: 5, status: 2)
        visit merchant_invoice_path(merchant_1, invoice_1)
 
        expect(page).to have_content("Total Revenue for Invoice #{invoice_1.id}: $15.0")
      end
    end

    describe 'I see that each invoice item status is a select field' do
      describe 'And I see that the invoice items current status is selected' do
        it 'And I see that the invoice items current status is selected' do
          merchant1 = Merchant.create!(name: "Bob")
          merchant2 = Merchant.create!(name: "Mark")
          customer1 = Customer.create!(first_name: "Jolene", last_name: "Jones")
          invoice_1 = customer1.invoices.create!(status: 1, created_at: "2021-09-14 09:00:01")
          item1 = merchant1.items.create!(name: "item1", description: "this is item1 description", unit_price: 1)
          item2 = merchant1.items.create!(name: "item2", description: "this is item2 description", unit_price: 2)
          item3 = merchant1.items.create!(name: "item3", description: "this is item3 description", unit_price: 3)
          item4 = merchant2.items.create!(name: "item4", description: "this is item4 description", unit_price: 3)
          invoice_item1 = InvoiceItem.create!(item_id: item1.id, invoice_id: invoice_1.id, unit_price: item1.unit_price, quantity: 1, status: 0)
          invoice_item2 = InvoiceItem.create!(item_id: item2.id, invoice_id: invoice_1.id, unit_price: item2.unit_price, quantity: 1, status: 0)
          invoice_item3 = InvoiceItem.create!(item_id: item3.id, invoice_id: invoice_1.id, unit_price: item3.unit_price, quantity: 1, status: 0)  

          visit merchant_invoice_path(merchant1, invoice_1)

          expect(page).to have_content("Invoice Status:")
          expect(page.has_field? 'status').to eq(true)
          expect(page).to have_content("cancelled")
        end
      end

      describe 'When I click this select field' do
        describe 'Then I can select a new status for the Item' do
          describe 'And next to the select field I see a button to "Update Item Status"' do
            it ' I click this button I am taken back to the merchant invoice show page And I see that my Items status has now been updated' do
              merchant1 = Merchant.create!(name: "Bob")
              merchant2 = Merchant.create!(name: "Mark")
              customer1 = Customer.create!(first_name: "Jolene", last_name: "Jones")
              invoice_1 = customer1.invoices.create!(status: 1, created_at: "2021-09-14 09:00:01")
              item1 = merchant1.items.create!(name: "item1", description: "this is item1 description", unit_price: 1)
              item2 = merchant1.items.create!(name: "item2", description: "this is item2 description", unit_price: 2)
              item3 = merchant1.items.create!(name: "item3", description: "this is item3 description", unit_price: 3)
              item4 = merchant2.items.create!(name: "item4", description: "this is item4 description", unit_price: 3)
              invoice_item1 = InvoiceItem.create!(item_id: item1.id, invoice_id: invoice_1.id, unit_price: item1.unit_price, quantity: 1, status: 0)
              invoice_item2 = InvoiceItem.create!(item_id: item2.id, invoice_id: invoice_1.id, unit_price: item2.unit_price, quantity: 1, status: 0)
              invoice_item3 = InvoiceItem.create!(item_id: item3.id, invoice_id: invoice_1.id, unit_price: item3.unit_price, quantity: 1, status: 0)  

              visit merchant_invoice_path(merchant1, invoice_1)

              expect(page).to have_content("Invoice Status:")
              expect(page).to have_content("cancelled")

              select "in progress", from: "Status"
              click_button "Update Invoice Status"
              expect(page).to have_content("in progress")
            end
          end
        end
      end
    end
  end

  describe 'I see the total revenue for my merchant from this invoice(not including discounts)' do
    describe 'I see the total discounted revenue for my merchant from this invoice' do
      it 'displays total revenue before discounts and total after discounts' do
        merchant_1 = create(:random_merchant)
        customer_1 = create(:random_customer)
        invoice_1 = customer_1.invoices.create!(status: 1)
        bulk_discount_1 = merchant_1.bulk_discounts.create!(percentage_discount: 20, quantity_threshold: 10)
        item_1 = merchant_1.items.create!(name: "Lemons", description: "Sour", unit_price: 100)
        item_2 = merchant_1.items.create!(name: "Limes", description: "Citrus", unit_price: 100)
        invoice_item_1 = InvoiceItem.create!(item: item_1, invoice: invoice_1, unit_price: 100, quantity: 10, status: 2)
        invoice_item_2 = InvoiceItem.create!(item: item_2, invoice: invoice_1, unit_price: 100, quantity: 5, status: 2)

        visit merchant_invoice_path(merchant_1, invoice_1)
        
        expect(page).to have_content("Total Revenue for Invoice #{invoice_1.id}: $15.0")
        expect(page).to have_content("Total Revenue After Discount: $13.0")
      end
    end
  end

  describe 'Next to each invoice I see a link to the show page for the bulk discount that was applied (if any)' do
    it 'When a bulk discount is applied, it links to the show page for that bulk discount' do
      merchant_1 = create(:random_merchant)
      customer_1 = create(:random_customer)
      invoice_1 = customer_1.invoices.create!(status: 1)
      bulk_discount_1 = merchant_1.bulk_discounts.create!(percentage_discount: 20, quantity_threshold: 10)
      item_1 = merchant_1.items.create!(name: "Lemons", description: "Sour", unit_price: 100)
      item_2 = merchant_1.items.create!(name: "Limes", description: "Citrus", unit_price: 100)
      invoice_item_1 = InvoiceItem.create!(item: item_1, invoice: invoice_1, unit_price: 100, quantity: 10, status: 2)
      invoice_item_2 = InvoiceItem.create!(item: item_2, invoice: invoice_1, unit_price: 100, quantity: 5, status: 2)

      visit merchant_invoice_path(merchant_1, invoice_1)
      
      within "#invoice_item-#{invoice_item_1.id}" do
        expect(page).to have_content("Bulk Discount Applied: #{bulk_discount_1.id}")
        click_link "#{bulk_discount_1.id}"
      end
    
      expect(current_path).to eq(merchant_bulk_discount_path(merchant_1, bulk_discount_1))
    end
  end
end
