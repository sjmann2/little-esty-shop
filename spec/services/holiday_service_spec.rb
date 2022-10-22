require "rails_helper"

RSpec.describe(HolidayService) do
  it "returns an HTTP response of US holidays", :vcr do
    holidays = HolidayService.get_us_holidays

    expect(holidays).to be_an(Array)
    expect(holidays.count).to eq(12)
    expect(holidays[0]).to be_a(Hash)
    expect(holidays[0]).to have_key(:name)
    expect(holidays[0][:name]).to be_a(String)
    expect(holidays[0]).to have_key(:date)
    expect(holidays[0][:date]).to be_a(String)
  end
end
