module Api::Controllers::MomentYears
  class Index
    include Api::Action

    def call(params)
      result = MomentRepository.all_available_years
      self.body = JSON.generate({
        available_years: result,
        available_years_formatted: formatted_years(result)
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
