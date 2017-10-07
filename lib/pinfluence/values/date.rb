module Values
  class Date
    attr_reader :date

    def initialize(date)
      @date = date
    end

    def formatted
      "#{date} AD"
    end
  end
end
