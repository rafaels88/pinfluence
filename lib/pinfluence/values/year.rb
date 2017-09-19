module Values
  class Year
    attr_reader :year

    def initialize(year)
      @year = year
    end

    def formatted
      if year.negative?
        @positive_year = year * -1
        "#{@positive_year} BC"
      elsif year.positive?
        "#{year} AD"
      else
        year.to_s
      end
    end
  end
end
