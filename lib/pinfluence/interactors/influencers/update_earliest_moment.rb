require_relative '../interactor'

module Influencers
  class UpdateEarliestMoment
    include Interactor

    attr_reader :influencer, :opts

    def initialize(influencer:, opts: {})
      @influencer = influencer
      @opts = opts
    end

    def call
      if influencer.person?
        update_person!
      elsif influencer.event?
        update_event!
      end
    end

    private

    def update_person!
      UpdatePerson.call(
        person: { id: influencer.id, earliest_year: earliest_year },
        opts: opts
      )
    end

    def update_event!
      UpdateEvent.call(
        event: { id: influencer.id, earliest_year: earliest_year },
        opts: opts
      )
    end

    def earliest_year
      MomentRepository.new.earliest_moment_of_an_influencer(influencer).year_begin
    end
  end
end
