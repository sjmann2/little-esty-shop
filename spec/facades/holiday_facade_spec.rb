require 'rails_helper'

RSpec.describe HolidayFacade do
  it 'returns the 3 upcoming US holidays', :vcr do
    result = HolidayFacade.three_upcoming_holidays
    expect(result).to be_an(Array)
    expect(result.count).to eq(3)
    expect(result[0]).to have_key(:name)
    expect(result[0][:name]).to be_a(String)
    expect(result[0]).to have_key(:date)
    expect(result[0][:date]).to be_a(String)
  end
end