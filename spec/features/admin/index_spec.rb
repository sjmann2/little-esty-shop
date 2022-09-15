require 'rails_helper'

RSpec.describe 'the admin dashboard' do
  describe 'When I visit the admin dashboard' do
    describe 'I see a header indicating I am on the admin dashboard' do
      it 'has a header on the admin dashboard' do
        visit admin_index_path

        expect(page).to have_content("Admin Dashboard")
      end
    end

    describe 'I see a link to the admin merchants index and the admin invoices index' do
      it 'links to the admin merchants index' do
        visit admin_index_path

        click_link "Admin merchants page"

        expect(current_path).to eq('/admin/merchants')
      end

      it 'links to the admin invoices index' do
        visit admin_index_path

        click_link 'Admin invoices page'

        expect(current_path).to eq('/admin/invoices')
      end
    end
     
    describe 'the top 5 customers who have conducted largest number of succesful transactions' do
      it 'lists the top 5 customers and number of successful transactions they have' do
        customer_1 = Customer.create!(first_name: 'Sandy', last_name: 'Busch')
        customer_2 = Customer.create!(first_name: 'Josh', last_name: 'Mann')
        customer_3 = Customer.create!(first_name: 'Miya', last_name: 'Yang')
        customer_4 = Customer.create!(first_name: 'Angel', last_name: 'Olsen')
        customer_5 = Customer.create!(first_name: 'Max', last_name: 'Smelter')
        customer_6 = Customer.create!(first_name: 'Bobby', last_name: 'Brown')
        customer_7 = Customer.create!(first_name: 'Jessica', last_name: 'Alba') 

        invoice_1 = Invoice.create!(customer_id: customer_1.id, status: 'completed')
        invoice_8 = Invoice.create!(customer_id: customer_1.id, status: 'completed')
        invoice_13 = Invoice.create!(customer_id: customer_1.id, status: 'completed')

        invoice_9 = Invoice.create!(customer_id: customer_2.id, status: 'completed')
        invoice_2 = Invoice.create!(customer_id: customer_2.id, status: 'completed')

        invoice_10 = Invoice.create!(customer_id: customer_3.id, status: 'completed')
        invoice_3 = Invoice.create!(customer_id: customer_3.id, status: 'completed')
        invoice_15 = Invoice.create!(customer_id: customer_3.id, status: 'completed')

        invoice_11 = Invoice.create!(customer_id: customer_4.id, status: 'completed')
        invoice_4 = Invoice.create!(customer_id: customer_4.id, status: 'completed')

        invoice_12 = Invoice.create!(customer_id: customer_5.id, status: 'completed')
        invoice_5 = Invoice.create!(customer_id: customer_5.id, status: 'completed')

        invoice_6 = Invoice.create!(customer_id: customer_6.id, status: 'completed')

        invoice_7 = Invoice.create!(customer_id: customer_7.id, status: 'completed')
        invoice_14 = Invoice.create!(customer_id: customer_7.id, status: 'completed')

        transaction_1 = Transaction.create!(invoice_id: invoice_1.id, credit_card_number: 4654405418249632, credit_card_expiration_date: '', result: 'success' )
        transaction_2 = Transaction.create!(invoice_id: invoice_2.id, credit_card_number: 4654405428249632, credit_card_expiration_date: '', result: 'success' )
        transaction_3 = Transaction.create!(invoice_id: invoice_3.id, credit_card_number: 4654405415249632, credit_card_expiration_date: '', result: 'success' )
        transaction_4 = Transaction.create!(invoice_id: invoice_4.id, credit_card_number: 4654405411249632, credit_card_expiration_date: '', result: 'success' )
        transaction_5 = Transaction.create!(invoice_id: invoice_5.id, credit_card_number: 4654405238249632, credit_card_expiration_date: '', result: 'success' )
        transaction_6 = Transaction.create!(invoice_id: invoice_6.id, credit_card_number: 4654405898249632, credit_card_expiration_date: '', result: 'success' )
        transaction_7 = Transaction.create!(invoice_id: invoice_7.id, credit_card_number: 4654405408249632, credit_card_expiration_date: '', result: 'success' )
        transaction_8 = Transaction.create!(invoice_id: invoice_8.id, credit_card_number: 4654405412249632, credit_card_expiration_date: '', result: 'success' )
        transaction_9 = Transaction.create!(invoice_id: invoice_9.id, credit_card_number: 4654405408249552, credit_card_expiration_date: '', result: 'success' )
        transaction_10 = Transaction.create!(invoice_id: invoice_10.id, credit_card_number: 2654405408249632, credit_card_expiration_date: '', result: 'success' )
        transaction_11 = Transaction.create!(invoice_id: invoice_11.id, credit_card_number: 1654405408249632, credit_card_expiration_date: '', result: 'success' )
        transaction_12 = Transaction.create!(invoice_id: invoice_12.id, credit_card_number: 6654405408249632, credit_card_expiration_date: '', result: 'success' )
        transaction_13 = Transaction.create!(invoice_id: invoice_13.id, credit_card_number: 6654405408209632, credit_card_expiration_date: '', result: 'failed' )
        transaction_14 = Transaction.create!(invoice_id: invoice_14.id, credit_card_number: 9654405408209632, credit_card_expiration_date: '', result: 'failed' )
        transaction_14 = Transaction.create!(invoice_id: invoice_15.id, credit_card_number: 9654405408209632, credit_card_expiration_date: '', result: 'success' )

        visit admin_index_path
        
        expect(page).to have_content("Top Customers")
        
        within "#customer-#{customer_1.id}" do
          expect(page).to have_content("#{customer_1.first_name} #{customer_1.last_name} - 2 purchases")
          expect(page).to_not have_content("#{customer_3.first_name}")
        end

        within "#customer-#{customer_2.id}" do
          expect(page).to have_content("#{customer_2.first_name} #{customer_2.last_name} - 2 purchases")
          expect(page).to_not have_content("#{customer_1.first_name}")
        end

        within "#customer-#{customer_3.id}" do
          expect(page).to have_content("#{customer_3.first_name} #{customer_3.last_name} - 3 purchases")
        end
      end
    end

    describe 'I see a section for incomplete invoices' do
      describe 'I see a list of the ids of all invoices that have items that are not shipped' do
        describe 'And each invoice id links to that invoices admin show page' do
          it 'lists all invoices that have items that are not shipped' do
            customer_1 = Customer.create!(first_name: 'Sandy', last_name: 'Busch')
            customer_2 = Customer.create!(first_name: 'Josh', last_name: 'Mann')
            customer_3 = Customer.create!(first_name: 'Miya', last_name: 'Yang')
            customer_4 = Customer.create!(first_name: 'Angel', last_name: 'Olsen')
            customer_5 = Customer.create!(first_name: 'Max', last_name: 'Smelter')

            invoice_1 = Invoice.create!(customer_id: customer_1.id, status: 'completed')
            invoice_2 = Invoice.create!(customer_id: customer_2.id, status: 'completed')
            invoice_3 = Invoice.create!(customer_id: customer_3.id, status: 'completed')
            invoice_4 = Invoice.create!(customer_id: customer_4.id, status: 'completed')
            invoice_5 = Invoice.create!(customer_id: customer_5.id, status: 'completed')

            merchant_1 = Merchant.create!(name: 'Schroder-Jerde')
            merchant_2 = Merchant.create!(name: 'Bradley and Sons')

            item_1 = Item.create!(name: 'Item Qui Esse', description: 'Nihil autem sit odio', unit_price: 75107, merchant_id: merchant_1.id)
            item_2 = Item.create!(name: 'Item Qui Esse', description: 'Nihil autem sit odio', unit_price: 75107, merchant_id: merchant_1.id)
            item_3 = Item.create!(name: 'Item Qui Esse', description: 'Nihil autem sit odio', unit_price: 75107, merchant_id: merchant_1.id)
            item_4 = Item.create!(name: 'Item Qui Esse', description: 'Nihil autem sit odio', unit_price: 75107, merchant_id: merchant_2.id)
            item_5 = Item.create!(name: 'Item Qui Esse', description: 'Nihil autem sit odio', unit_price: 75107, merchant_id: merchant_2.id)

            invoice_item_1 = InvoiceItem.create!(item_id: item_1.id, invoice_id: invoice_1.id, quantity: 3, unit_price: 3635, status: 'shipped')
            invoice_item_2 = InvoiceItem.create!(item_id: item_2.id, invoice_id: invoice_2.id, quantity: 31, unit_price: 13635, status: 'packaged')
            invoice_item_3 = InvoiceItem.create!(item_id: item_3.id, invoice_id: invoice_3.id, quantity: 13, unit_price: 1335, status: 'shipped')
            invoice_item_4 = InvoiceItem.create!(item_id: item_4.id, invoice_id: invoice_4.id, quantity: 30, unit_price: 1335, status: 'pending')
            invoice_item_5 = InvoiceItem.create!(item_id: item_5.id, invoice_id: invoice_5.id, quantity: 12, unit_price: 1365, status: 'packaged')
            
            visit admin_index_path

            expect(page).to have_content('Incomplete Invoices')
            expect(page).to have_content(invoice_item_2.invoice_id)
            expect(page).to have_content(invoice_item_4.invoice_id)
            expect(page).to_not have_content(invoice_item_1.invoice_id)           
          end

          it 'links to the invoice admin show page for every invoice id shown' do
            customer_2 = Customer.create!(first_name: 'Josh', last_name: 'Mann')       
            invoice_2 = Invoice.create!(customer_id: customer_2.id, status: 'completed')
            merchant_1 = Merchant.create!(name: 'Schroder-Jerde')
            item_2 = Item.create!(name: 'Item Qui Esse', description: 'Nihil autem sit odio', unit_price: 75107, merchant_id: merchant_1.id)
            invoice_item_2 = InvoiceItem.create!(item_id: item_2.id, invoice_id: invoice_2.id, quantity: 31, unit_price: 13635, status: 'packaged')

            visit admin_index_path

            click_link "#{invoice_item_2.invoice_id}"

            expect(current_path).to eq("/admin/invoices/#{invoice_item_2.invoice_id}")
          end
        end
      end
    end
  end
end
