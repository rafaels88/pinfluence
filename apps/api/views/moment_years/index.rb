module Api::Views::MomentYears
  class Index
    include Api::View

    def render
      raw JSON.generate({
        available_years: years,
        available_years_formatted: formatted_years(years)
      })
    end

    private

    def formatted_years(years)
      years.map do |y|
        if y < 0
          y *= -1
          "#{y} AC"
        elsif y > 0
          "#{y} DC"
        else
          y
        end
      end
    end
  end
end
