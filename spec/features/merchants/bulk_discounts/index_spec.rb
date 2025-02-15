require 'rails_helper'

RSpec.describe 'the bulk discounts index page' do
  describe 'When I visit the bulk discount index page' do
    describe 'I see all of my bulk discounts/percentage discount/quantity thresholds' do
      it 'displays all bulk discounts and each discount listed includes a link to its show page', :vcr do
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

        it 'displays a link to a form to create a new discount', :vcr do
          visit merchant_bulk_discounts_path(merchant_1)

          expect(page).to_not have_content("10% off 5 or more of an item")

          click_link "Create a new discount"

          expect(current_path).to eq(new_merchant_bulk_discount_path(merchant_1))
          
          fill_in "Percentage discount", with: "10"
          fill_in "Quantity threshold", with: "5"
          click_on "Create bulk discount"

          expect(current_path).to eq(merchant_bulk_discounts_path(merchant_1))
          
          expect(page).to have_content("10% off 5 or more of an item")
        end

        it 'Will not redirect if I do not fill in fields with valid data', :vcr do
          visit merchant_bulk_discounts_path(merchant_1)
          
          click_link "Create a new discount"

          fill_in "Percentage discount", with: "10%"
          fill_in "Quantity threshold", with: "five"
          click_on "Create bulk discount"

          expect(current_path).to eq(new_merchant_bulk_discount_path(merchant_1))
          expect(page).to have_content("Percentage discount is not a number")
        end
      end
    end

    describe 'Next to each discount I see a link to delete it' do
      describe 'When I click this link I am redirected to the index page and I no longer see the discount listed' do
        let!(:merchant_1) {create(:random_merchant)}
        let!(:bulk_discount_1) {merchant_1.bulk_discounts.create!(percentage_discount: 20, quantity_threshold: 10)}
        let!(:bulk_discount_2) {merchant_1.bulk_discounts.create!(percentage_discount: 30, quantity_threshold: 15)}

        it 'displays a link to delete a bulk discount', :vcr do
          visit merchant_bulk_discounts_path(merchant_1)
          
          expect(page).to have_content("20% off 10 or more of an item")

          within "#bulk-discount-#{bulk_discount_1.id}" do
            click_on "Delete discount"
          end

          expect(current_path).to eq(merchant_bulk_discounts_path(merchant_1))
          expect(page).to_not have_content("20% off 10 or more of an item")
        end
      end
    end

    describe 'I see a section for upcoming holidays' do
      let!(:merchant_1) {create(:random_merchant)}
      let!(:bulk_discount_1) {merchant_1.bulk_discounts.create!(percentage_discount: 20, quantity_threshold: 10)}
      let!(:bulk_discount_2) {merchant_1.bulk_discounts.create!(percentage_discount: 30, quantity_threshold: 15)}

      it 'Lists the name of the next 3 upcoming US holidays', :vcr do
       visit merchant_bulk_discounts_path(merchant_1)
        
       expect(page).to have_content("Three upcoming US holidays")
      end
    end
  end
end
