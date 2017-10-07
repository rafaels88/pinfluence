module Moments
  class ListAvailableDatesInSystem
    include Interactor

    attr_reader :opts, :moment_repository

    def initialize(opts: {})
      @opts = opts
      @moment_repository = opts[:moment_repository] || MomentRepository.new
    end

    def call
      moment_repository.all_dates_begin.map do |moment|
        Values::Date.new moment.date_begin
      end
    end
  end
end
