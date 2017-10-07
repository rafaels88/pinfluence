require_relative './interactor'
require_relative './moments/concerns/persister'

class CreateMoment
  include Interactor
  include Moments::Concerns::Persister

  def initialize(influencer:, locations:, moment:, opts: {})
    @locations_params = locations
    @influencer_params = influencer
    @moment_params = moment
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

    moment = repository.create(build_moment(influencer))
    persist_locations(moment)
    update_influencer_earliest_moment(influencer)
    moment
  end

  private

  def build_moment(influencer)
    Moment.new(
      "#{influencer.type}_id".to_sym => influencer.id,
      date_begin: moment_params[:date_begin],
      date_end: normalized_date_end
    )
  end
end
