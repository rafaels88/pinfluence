module Api::Views::MomentYears
  class Index
    include Api::View

    def render
      raw JSON.generate(
        data: {
          available_years: years,
          available_years_formatted: formatted_years(years)
        }
      )
    end

    private

    def formatted_years(years)
      years.map do |y|
        if y < 0
          y *= -1
          "#{y} BC"
        elsif y > 0
          "#{y} AD"
        else
          y
        end
      end
    end
  end
end
