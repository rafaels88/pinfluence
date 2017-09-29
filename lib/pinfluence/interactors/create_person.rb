require_relative './interactor'
require_relative './influencers/concerns/persister'

class CreatePerson
  include Interactor
  include Influencers::Concerns::Persister

  INFLUENCER_PARAMS_WHITELIST = %i[name gender].freeze

  def initialize(person:, moments: [], opts: {})
    @influencer_params = person
    @moments_params = moments

    @influencer_repository = opts[:influencer_repository] || PersonRepository.new
    @moment_repository = opts[:moment_repository] || MomentRepository.new
    @indexer = opts[:indexer] || Influencers::Indexer
    @index_object = opts[:index_object] || Influencers::EventIndexObject
  end

  def call
    person = influencer_repository.create(persist_influencer_params)
    persist_moments_for person

    persist_index(reloaded_influencer(person.id))
    reloaded_influencer(person.id)
  end
end
