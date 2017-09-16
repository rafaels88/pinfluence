module Values
  class Year
    attr_reader :year

    def initialize(year)
      @year = year
    end

    def formatted
      if year < 0
        @positive_year = year * -1
        "#{@positive_year} BC"
      elsif year > 0
        "#{year} AD"
      else
        year.to_s
      end
    end
  end
end
