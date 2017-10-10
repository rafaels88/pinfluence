require 'date'

module Values
  class Date
    attr_reader :date

    def initialize(date)
      @date = date
    end

    def formatted
      return "#{date.strftime('%d/%m/%Y').delete('-')} BC" if date.year.negative?
      "#{date.strftime('%d/%m/%Y')} AD"
    end
  end
end
