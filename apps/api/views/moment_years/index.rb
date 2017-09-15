module Api::Views::MomentYears
  class Index
    include Api::View

    def render
      raw JSON.generate(
        data: {
          available_years: years.map(&:year),
          available_years_formatted: years.map(&:formatted)
        }
      )
    end
  end
end
