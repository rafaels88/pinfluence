require_relative './interactor'
require_relative './moments/concerns/persister'

class UpdateMoment
  include Interactor
  include Moments::Concerns::Persister

  def initialize(moment:, influencer:, locations:, opts: {})
    @moment_params = moment
    @locations_params = locations
    @influencer_params = influencer
    @opts = opts

    @repository = opts.fetch(:repository, MomentRepository.new)
    @person_repository = opts.fetch(:person_repository, PersonRepository.new)
    @location_service = opts.fetch(:location_service, Locations::Searcher.new)

    @errors = []
  end

  def call
    clean_empty_locations!
    check_locations!
    return unless errors.empty?

    influencer = find_influencer || create_influencer

    updated_moment = repository.update(moment_params[:id], persist_params(influencer))
    persist_locations(updated_moment)
    update_influencer_earliest_moment(influencer)
    updated_moment
  end

  private

  def persist_params(influencer)
    {
      "#{influencer.type}_id".to_sym => influencer.id,
      date_begin: normalized_date_begin,
      date_end: normalized_date_end
    }
  end
end
