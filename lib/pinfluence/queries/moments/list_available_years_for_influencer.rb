require_relative '../../interactors/interactor'

module Moments
  class ListAvailableYearsForInfluencer
    include Interactor

    attr_reader :influencer_params, :moment_repository

    def initialize(influencer:, opts: {})
      @influencer_params = influencer
      @moment_repository = opts[:moment_repository] || MomentRepository.new
    end

    def call
      (min_year..max_year).to_a.map { |y| Values::Year.new y }
    end

    private

    def max_year
      moments.last.year_end || Time.now.year
    end

    def min_year
      moments.first.year_begin
    end

    def moments
      @_moments ||= moment_repository.search_by_influencer influencer
    end

    def influencer
      @_influencer ||= Influencers::Find.call(id: influencer_params[:id], type: influencer_params[:type])
    end
  end
end
