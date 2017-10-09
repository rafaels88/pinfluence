module Moments
  class ListAvailableDatesForInfluencer
    include Interactor
    include DatesLister

    attr_reader :influencer_params, :opts, :moment_repository

    def initialize(influencer:, opts: {})
      @influencer_params = influencer
      @opts = opts

      @moment_repository = opts[:moment_repository] || MomentRepository.new
    end

    def call
      fill_gap_years(dates).map { |d| Values::Date.new d }
    end

    private

    def dates
      dates_begin + [moments.last.date_end]
    end

    def dates_begin
      return @_dates_begin if @_dates_begin

      @_dates_begin = moments.map(&:date_begin)
    end

    def moments
      @_moments ||= moment_repository.search_by_influencer influencer
    end

    def influencer
      @_influencer ||= Influencers::Find.call(id: influencer_params[:id], type: influencer_params[:type])
    end
  end
end
