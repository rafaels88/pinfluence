require_relative './interactor'
require_relative './influencers/concerns/persister'

class UpdateEvent
  include Interactor
  include Influencers::Concerns::Persister

  INFLUENCER_PARAMS_WHITELIST = %i[name earliest_date].freeze

  def initialize(event:, moments: [], opts: {})
    @influencer_params = event
    @moments_params = moments

    @opts = opts
    @influencer_repository = opts[:influencer_repository] || EventRepository.new
    @moment_repository = opts[:moment_repository] || MomentRepository.new
    @indexer = opts[:indexer] || Influencers::Indexer
    @index_object = opts[:index_object] || Influencers::EventIndexObject
  end

  def call
    updated_event = influencer_repository.update(influencer_params[:id], **persist_influencer_params)
    persist_moments_for updated_event

    persist_index(reloaded_influencer(updated_event.id))
    reloaded_influencer(updated_event.id)
  end
end
