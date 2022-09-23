# Merchant Bulk Discount Show

# As a merchant
# When I visit my bulk discount show page
# Then I see the bulk discount's quantity threshold and percentage discount
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
  end
end