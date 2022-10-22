class HolidayFacade
  def self.three_upcoming_holidays
    holiday_data = HolidayService.get_us_holidays
    holidays = holiday_data.each do |data|
      data[:name]
    end

    holidays.take(3)
  end
end
