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
        
        within "#bulk-discount-#{bulk_discount_2.id}" do
          expect(page).to have_link('View Bulk Discount')

          click_link 'View Bulk Discount'
        end

        expect(current_path).to eq(merchant_bulk_discount_path(merchant_1, bulk_discount_2))
      end
    end

    describe 'I click a link to create a new discount that takes me to a new page' do
      describe 'When I fill in the form with valid data I am redirected to the bulk discount index' do
        let!(:merchant_1) {create(:random_merchant)}
        let!(:bulk_discount_1) {merchant_1.bulk_discounts.create!(percentage_discount: 20, quantity_threshold: 10)}
        let!(:bulk_discount_2) {merchant_1.bulk_discounts.create!(percentage_discount: 30, quantity_threshold: 15)}

        it 'displays a link to a form to create a new discount' do
          visit merchant_bulk_discounts_path(merchant_1)

          expect(page).to_not have_content("10% off 5 or more of an item")

          click_link "Create a new discount"

          expect(current_path).to eq(new_merchant_bulk_discount(merchant_1))

          fill_in "Percentage_discount", with: "10"
          fill_in "Quantity threshold", with: "5"
          click_on "Submit"

          expect(current_path).to eq(merchant_bulk_discounts_path(merchant_1))

          expect(page).to have_content("10% off 5 or more of an item")
        end

        it 'Will not redirect if I do not fill in fields with valid data' do
          visit merchant_bulk_discounts_path(merchant_1)
          
          click_link "Create a new discount"

          fill_in "Percentage_discount", with: "10%"
          fill_in "Quantity threshold", with: "five"
          click_on "Submit"

          expect(current_path).to eq(merchant_bulk_discounts_path(merchant_1))
          expect(page).to have_content("Percentage discount is not a number")
        end
      end
    end
  end
end
# Merchant Bulk Discount Create

# As a merchant
# When I visit my bulk discounts index
# Then I see a link to create a new discount
# When I click this link
# Then I am taken to a new page where I see a form to add a new bulk discount
# When I fill in the form with valid data
# Then I am redirected back to the bulk discount index
# And I see my new bulk discount listed