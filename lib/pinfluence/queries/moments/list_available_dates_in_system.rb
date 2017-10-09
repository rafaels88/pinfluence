module Moments
  class ListAvailableDatesInSystem
    include Interactor
    include DatesLister

    attr_reader :opts, :moment_repository

    def initialize(opts: {})
      @opts = opts
      @moment_repository = opts[:moment_repository] || MomentRepository.new
    end

    def call
      fill_gap_years([first_date, last_date]).map do |date|
        Values::Date.new date
      end
    end

    private

    def first_date
      year = moment_repository.first_ordered_by_date_begin.date_begin.year
      Date.new(year, 1, 1)
    end

    def last_date
      year = moment_repository.first_ordered_by_date_begin(:desc).date_begin.year
      Date.new(year, 1, 1)
    end
  end
end
