require_relative '../interactor'

module Influencers
  class PersistInfluencer
    include Interactor

    attr_reader :influencer_params, :opts

    def initialize(influencer:, opts: {})
      @influencer_params = influencer
      @opts = opts
    end

    def call
      action_klasses[type][action].call(action_args[type][action])
    end

    private

    def action_klasses
      {
        person: { create: CreatePerson, update: UpdatePerson },
        event: { create: CreateEvent, update: UpdateEvent }
      }
    end

    def action_args
      {
        person: { create: person_create_args, update: person_update_args },
        event: { create: event_create_args, update: event_update_args }
      }
    end

    def person_create_args
      { person: { name: influencer_params[:name], gender: influencer_params[:gender] }, opts: opts }
    end

    def person_update_args
      {
        person: {
          id: influencer_params[:id], name: influencer_params[:name], gender: influencer_params[:gender]
        },
        opts: opts
      }
    end

    def event_create_args
      { event: { name: influencer_params[:name] }, opts: opts }
    end

    def event_update_args
      { event: { id: influencer_params[:id], name: influencer_params[:name] }, opts: opts }
    end

    def type
      influencer_params[:type].to_sym
    end

    def action
      return :create if influencer_params[:id].to_s.empty?
      :update
    end
  end
end
