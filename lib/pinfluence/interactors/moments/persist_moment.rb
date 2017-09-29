module Moments
  class PersistMoment
    include Interactor

    attr_reader :moment_params, :locations_params, :influencer_params,
                :opts

    def initialize(moment:, influencer:, locations:, opts: {})
      @moment_params = moment
      @locations_params = locations
      @influencer_params = influencer
      @opts = opts
    end

    def call
      return unless enable_to_persist?

      return CreateMoment.call(persist_params) if new_moment?

      UpdateMoment.call(persist_params)
    end

    private

    def enable_to_persist?
      !moment_params[:year_begin].to_s.empty?
    end

    def new_moment?
      moment_params[:id].to_s.empty?
    end

    def persist_params
      {
        influencer: influencer_params,
        locations: locations_params,
        moment: moment_params,
        opts: opts
      }
    end
  end
end
