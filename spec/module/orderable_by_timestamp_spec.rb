require "spec_helper"


RSpec.describe(OrderableByTimestamp) do
  it("should order all created_at in asc order") do
    @orderableByTimestamp_dummy = OrderableByTimestamp.new
    @orderableByTimestamp_dummy.extend(OrderableByTimestamp)
    invoice2 = customer1.invoices.create!(    status: 1,     created_at: "Sunday, July 17, 2019")
    invoice1 = customer1.invoices.create!(    status: 1,     created_at: "Monday, July 18, 2019")
    invoice3 = customer1.invoices.create!(    status: 1,     created_at: "Tuesday, July 18, 2019")
    expect(@orderableByTimestamp_dummy.index).to(eq([invoice1, invoice2, invoice3]))
  end
end
