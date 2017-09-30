require_relative './interactor'
require_relative './influencers/concerns/persister'

class CreateEvent
  include Interactor
  include Influencers::Concerns::Persister

  INFLUENCER_PARAMS_WHITELIST = %i[name].freeze

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
    created_event = influencer_repository.create(persist_influencer_params)
    persist_moments_for created_event

    persist_index(reloaded_influencer(created_event.id))
    reloaded_influencer(created_event.id)
  end
end
