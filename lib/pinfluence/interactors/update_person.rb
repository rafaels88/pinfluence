require_relative './interactor'
require_relative './influencers/concerns/persister'

class UpdatePerson
  include Interactor
  include Influencers::Concerns::Persister

  INFLUENCER_PARAMS_WHITELIST = %i[name gender earliest_year].freeze

  def initialize(person:, moments: [], opts: {})
    @influencer_params = person
    @moments_params = moments

    @influencer_repository = opts[:influencer_repository] || PersonRepository.new
    @moment_repository = opts[:moment_repository] || MomentRepository.new
    @indexer = opts[:indexer] || Influencers::Indexer
    @index_object = opts[:index_object] || Influencers::PersonIndexObject
  end

  def call
    updated_person = influencer_repository.update(influencer_params[:id], **persist_influencer_params)
    persist_moments_for updated_person

    persist_index(reloaded_influencer(updated_person.id))
    reloaded_influencer(updated_person.id)
  end
end
