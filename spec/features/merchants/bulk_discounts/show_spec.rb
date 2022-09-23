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

          expect(current_path).to eq(edit_merchant_bulk_discount(merchant_1, bulk_discount_1))
          expect(page.has_field? 'Percentage discount').to be(true)
          expect(page.has_field? 'Quantity threshold').to be(true)

          expect(page).to have_content('20')
          expect(page).to have_content('10')

          fill_in 'Percentage discount', with: '15'
          click_button 'Submit'

          expect(current_path).to eq(merchant_bulk_discount_path(merchant_1, bulk_discount_1))

          expect(page).to have_content("Percentage discount: 15")
          expect(page).to have_content("Quantity threshold: 10")
        end
      end
    end
  end
end
# Merchant Bulk Discount Edit

# As a merchant
# When I visit my bulk discount show page
# Then I see a link to edit the bulk discount
# When I click this link
# Then I am taken to a new page with a form to edit the discount
# And I see that the discounts current attributes are pre-poluated in the form
# When I change any/all of the information and click submit
# Then I am redirected to the bulk discount's show page
# And I see that the discount's attributes have been updated