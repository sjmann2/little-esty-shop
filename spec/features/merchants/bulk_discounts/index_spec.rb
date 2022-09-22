# Merchant Bulk Discounts Index

# As a merchant
# When I visit my merchant dashboard
# Then I see a link to view all my discounts
# When I click this link
# Then I am taken to my bulk discounts index page
# Where I see all of my bulk discounts including their
# percentage discount and quantity thresholds
# And each bulk discount listed includes a link to its show page
require 'rails_helper'

RSpec.describe 'the bulk discounts index page' do
  describe 'When I visit the bulk discount index page' do
    describe 'I see all of my bulk discounts/percentage discount/quantity thresholds' do
      it 'displays all bulk discounts and each discount listed includes a link to its show page' do
        merchant_1 = create(:random_merchant)
        merchant_2 = create(:random_merchant)

        bulk_discount_1 = merchant_1.bulk_discounts.create!(percentage_discount: 20, quantity_threshold: 10)
        bulk_discount_2 = merchant_1.bulk_discounts.create!(percentage_discount: 30, quantity_threshold: 15)
        bulk_discount_3 = merchant_2.bulk_discounts.create!(percentage_discount: 25, quantity_threshold: 12)

        visit merchant_bulk_discounts_path(merchant_1)

        expect(page).to have_content("20% off 10 or more of an item")
        expect(page).to have_content("30% off 15 or more of an item")
        expect(page).to_not have_content("25% off 12 or more of an item")

        within "#bulk-discount-#{bulk_discount_1.id}" do
          expect(page).to have_link('View Bulk Discount')
        end
        save_and_open_page
        within "#bulk-discount-#{bulk_discount_2.id}" do
          expect(page).to have_link('View Bulk Discount')

          click_link 'View Bulk Discount'
        end

        expect(current_path).to eq(merchant_bulk_discount_path(merchant_1, bulk_discount_2))
      end
    end
  end
end