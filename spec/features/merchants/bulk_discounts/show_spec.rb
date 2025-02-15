require 'rails_helper'

RSpec.describe 'the bulk discount show page' do
  describe 'when I visit my bulk discount show page' do
    let!(:merchant_1) {create(:random_merchant)}
    let!(:bulk_discount_1) {merchant_1.bulk_discounts.create!(percentage_discount: 20, quantity_threshold: 10)}
    let!(:bulk_discount_2) {merchant_1.bulk_discounts.create!(percentage_discount: 30, quantity_threshold: 15)}

    it 'I see the bulk discount quantity threshold/percentage discount' do
      visit merchant_bulk_discount_path(merchant_1, bulk_discount_1)

      expect(page).to have_content("Percentage discount: 20")
      expect(page).to have_content("Quantity threshold: 10")

      expect(page).to_not have_content("Percentage discount: 30")
      expect(page).to_not have_content("Quantity threshold: 15")
    end

    describe 'When I click a link to edit the bulk discount I am taken to a new page with an edit form' do
      describe 'The form is pre-populated with current attributes and when I click submit I am redirected to the show page' do
        it 'Can edit the bulk discount' do
          visit merchant_bulk_discount_path(merchant_1, bulk_discount_1)

          expect(page).to have_content("Percentage discount: 20")
          expect(page).to have_content("Quantity threshold: 10")

          click_link "Edit bulk discount"

          expect(current_path).to eq(edit_merchant_bulk_discount_path(merchant_1, bulk_discount_1))
          expect(page).to have_field('Percentage discount', with: '20')
          expect(page).to have_field('Quantity threshold', with: '10')
          
          fill_in 'Percentage discount', with: '15'
          click_button 'Submit'

          expect(current_path).to eq(merchant_bulk_discount_path(merchant_1, bulk_discount_1))

          expect(page).to have_content("Percentage discount: 15")
          expect(page).to have_content("Quantity threshold: 10")
        end

        it 'Will redirect to the edit form and flash an error message if form is not filled in with correct values' do
          visit merchant_bulk_discount_path(merchant_1, bulk_discount_1)
          
          click_link "Edit bulk discount"

          fill_in 'Percentage discount', with: ''
          click_button 'Submit'

          expect(current_path).to eq(edit_merchant_bulk_discount_path(merchant_1, bulk_discount_1))
          expect(page).to have_content('Error: Percentage discount is not a number')
        end
      end
    end
  end
end
