module Moments
  module DatesLister
    def fill_gap_years(dates)
      result = []
      dates.each_with_index do |date, i|
        if i.positive?
          last_year = dates[i - 1].year
          result += missing_dates_between(date.year, last_year)
        end

        result.push(date)
      end
      result
    end

    private

    def missing_dates_between(newest, oldest)
      return [] unless (newest - oldest) > 1

      (oldest...newest).to_a[1..-1].map { |y| Date.new(y) unless y.zero? }.compact
    end
  end
end
