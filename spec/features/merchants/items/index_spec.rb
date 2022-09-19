require "rails_helper"


RSpec.describe "the merchant items index"  do



    it "I see the name of my merchant"  do
        merchant1 = Merchant.create!(name: "Bob")

        visit "/merchants/#{merchant1.id}/items"
        expect(page).to have_content("#{merchant1.name} Items")
    end

    it "I see all the items associated with that merchant" do
        merchant1 = Merchant.create!(name: "Bob")
        merchant2 = Merchant.create!(name: "Jolene")
        item1 = merchant1.items.create!(name: "item1", description: "this is item1 description", unit_price: 1)
        item2 = merchant1.items.create!(name: "item2", description: "this is item2 description", unit_price: 2)
        item3 = merchant1.items.create!(name: "item3", description: "this is item3 description", unit_price: 3)
        item4 = merchant2.items.create!(name: "item3", description: "this is item4 description", unit_price: 3)

        visit "/merchants/#{merchant1.id}/items"

        expect(page).to have_content("item1")
        expect(page).to have_content("item2")
        expect(page).to have_content("item3")
        expect(page).to_not have_content("item4")
    end

    describe "enable/disable items" do
        before(:each) do

            @merchant1 = Merchant.create!(name: "Bob")
            @merchant2 = Merchant.create!(name: "Jolene")
            @item1 = @merchant1.items.create!(name: "Crows", description: "this is item1 description", unit_price: 1)
            @item2 = @merchant1.items.create!(name: "Bees", description: "this is item2 description", unit_price: 2)
            @item3 = @merchant1.items.create!(name: "Swamp Monsters", description: "this is item3 description", unit_price: 3)
            @item4 = @merchant2.items.create!(name: "Diamonds", description: "this is item4 description", unit_price: 3)

            visit merchant_items_path(@merchant1)
        end

        it "has a button next to each item to change the enabled status of the item" do
            #add within block here
            expect(page).to have_button("Disable #{@item1.name}")
        end

        it "when I click that button, I am redirected to the merchant item index page" do
            #add within block here
            click_button("Disable #{@item1.name}")
            expect(current_path).to eq merchant_items_path
        end

        xit "and I see that the status of the item has changed" do
            click_button("Disable #{@item2.name}")
            expect(page).to have_button("Enable #{@item2.name}")
        end
    end
end