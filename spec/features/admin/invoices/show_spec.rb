require 'rails_helper'

describe 'the admin invoices show page' do
  describe 'When I visit an admin invoice show page' do
    it 'I see invoice id/status/created_at/customer full name' do
      customer_1 = create(:random_customer)
      customer_2 = create(:random_customer)

      invoice_1 = create(:random_invoice, customer: customer_1)
      invoice_2 = create(:random_invoice, customer: customer_2)

      visit admin_invoice_path(invoice_1)
      
      within "#invoice-#{invoice_1.id}" do
        expect(page).to have_content(invoice_1.id)
        expect(page).to_not have_content(invoice_2.id)
      end

      expect(page).to have_content(invoice_1.status)
      expect(page).to have_content(invoice_1.created_at.strftime('%A, %B %d, %Y'))
      expect(page).to have_content(customer_1.first_name)
      expect(page).to have_content(customer_1.last_name)
    end

    describe 'I see all items on the invoice including name/quantity/price sold/status' do
      it 'lists item name, quantity ordered, price sold at, and invoice item status' do
        customer_1 = create(:random_customer)
        customer_2 = create(:random_customer)

        invoice_1 = create(:random_invoice, customer: customer_1)
        #customer_1 has 3 invoices
        invoice_2 = create(:random_invoice, customer: customer_2)

        merchant_1 = create(:random_merchant)
        merchant_2 = create(:random_merchant)

        item_1 = create(:random_item, merchant_id: merchant_1.id)
        item_2 = create(:random_item, merchant_id: merchant_1.id)
        item_3 = create(:random_item, merchant_id: merchant_1.id)
        item_4 = create(:random_item, merchant_id: merchant_2.id)

        invoice_item_1 = create(:random_invoice_item, item_id: item_1.id, invoice_id: invoice_1.id)
        invoice_item_2 = create(:random_invoice_item, item_id: item_2.id, invoice_id: invoice_1.id)
        invoice_item_3 = create(:random_invoice_item, item_id: item_3.id, invoice_id: invoice_1.id)
        invoice_item_4 = create(:random_invoice_item, item_id: item_4.id, invoice_id: invoice_2.id)

        #invoice_items_1 has 3 items, all for customer_1
        visit admin_invoice_path(invoice_1)
        
        expect(page).to have_content(item_1.name)
        expect(page).to have_content(item_2.name)
        expect(page).to have_content(item_3.name)
        expect(page).to have_content(invoice_item_1.quantity)
        expect(page).to have_content(invoice_item_2.quantity)
        expect(page).to have_content(invoice_item_3.quantity)
        expect(page).to have_content(invoice_item_1.unit_price)
        expect(page).to have_content(invoice_item_2.unit_price)
        expect(page).to have_content(invoice_item_3.unit_price)
        expect(page).to have_content(invoice_item_1.status)
        expect(page).to have_content(invoice_item_2.status)
        expect(page).to have_content(invoice_item_3.status)

        expect(page).to_not have_content(item_4.name)
      end
    end

    describe 'I see the total revenue that will be generated from this invoice' do
      it 'displays total revenue generated for each invoice' do
        customer_1 = create(:random_customer)
        invoice_1 = create(:random_invoice, customer: customer_1)
        merchant_1 = create(:random_merchant)

        item_1 = create(:random_item, merchant_id: merchant_1.id)
        item_2 = create(:random_item, merchant_id: merchant_1.id)
        item_3 = create(:random_item, merchant_id: merchant_1.id)

        invoice_item_1 = InvoiceItem.create!(item_id: item_1.id, invoice_id: invoice_1.id, quantity: 2, unit_price: 4999, status: 'shipped')
        invoice_item_2 = InvoiceItem.create!(item_id: item_2.id, invoice_id: invoice_1.id, quantity: 1, unit_price: 2001, status: 'shipped')
        invoice_item_3 = InvoiceItem.create!(item_id: item_3.id, invoice_id: invoice_1.id, quantity: 4, unit_price: 4575, status: 'shipped')

        visit admin_invoice_path(invoice_1)

        expect(page).to have_content("Total Revenue for Invoice #{invoice_1.id}: $302.99")
      end
    end

    describe 'the invoice status is a select field and the current status is selected' do
      describe 'I can select a new status for the invoice and click a button to update invoice status' do
        it 'lists the invoice status as a select field with current status selected' do
          customer_1 = create(:random_customer)
          invoice_1 = Invoice.create!(status: 'in progress', customer: customer_1)

          visit admin_invoice_path(invoice_1)
          
          expect(page.has_field? 'status').to be true
          expect(page).to have_content('in progress')
        end

        it 'can select a new status for the invoice' do
          customer_1 = create(:random_customer)
          invoice_1 = Invoice.create!(status: 'in progress', customer: customer_1)

          visit admin_invoice_path(invoice_1)

          select "cancelled", from: "Status"
          click_on "Update Invoice Status"

          expect(current_path).to eq(admin_invoice_path(invoice_1))

          expect(page).to have_content('cancelled')
        end
      end
    end

    describe 'I see the total revenue from this invoice(not including discounts)' do
      describe 'I see the total discounted revenue from this invoice including bulk discounts' do
        it 'displays total revenue before discounts and total after discounts' do
          merchant_1 = create(:random_merchant)
          merchant_2 = create(:random_merchant)
          customer_1 = create(:random_customer)
          bulk_discount_1 = merchant_1.bulk_discounts.create!(percentage_discount: 20, quantity_threshold: 10)
          bulk_discount_2 = merchant_1.bulk_discounts.create!(percentage_discount: 30, quantity_threshold: 15)
          invoice_1 = customer_1.invoices.create!(status: 1)
          item_1 = merchant_1.items.create!(name: "Spoons", description: "Hold food", unit_price: 200)
          item_2 = merchant_1.items.create!(name: "Toe rings", description: "Stylish", unit_price: 500)
          item_3 = merchant_2.items.create!(name: "Fake spiders", description: "Spooky", unit_price: 350)
          invoice_item_1 = InvoiceItem.create!(item: item_1, invoice: invoice_1, unit_price: 200, quantity: 12, status: 2)
          invoice_item_2 = InvoiceItem.create!(item: item_2, invoice: invoice_1, unit_price: 500, quantity: 15, status: 2)
          invoice_item_3 = InvoiceItem.create!(item: item_3, invoice: invoice_1, unit_price: 350, quantity: 15, status: 2)

          visit admin_invoice_path(invoice_1)
        
          expect(page).to have_content("Total Revenue for Invoice #{invoice_1.id}: $151.5")
          expect(page).to have_content("Total Revenue After Discount: $124.2")
        end
      end
    end
  end
end
 

# Admin Invoice Show Page: Total Revenue and Discounted Revenue

# As an admin
# When I visit an admin invoice show page
# Then I see the total revenue from this invoice (not including discounts)
# And I see the total discounted revenue from this invoice which includes bulk discounts in the calculation

