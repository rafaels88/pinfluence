require_relative './interactor'

class CreateMoment
  include Interactor

  attr_reader :locations, :repository, :location_service

  def initialize(influencer:, locations:, moment:, opts: {})
    @locations = locations
    @influencer = influencer
    @moment = moment
    @opts = opts

    @repository = opts.fetch(:repository, MomentRepository.new)
    @location_service = opts.fetch(:location_service, Locations::Searcher.new)

    @errors = []
  end

  Result = Struct.new(:moment, :failure?, :success?, :errors)

  def call
    check_locations!

    if success?
      create_influencer_if_new!
      moment = repository.create(new_moment)
      add_locations_to_moment(moment)
    else
      moment = nil_moment
    end

    Result.new(moment, failure?, success?, @errors)
  end

  private

  def add_locations_to_moment(moment)
    locations.each do |location_param|
      location_param.delete(:id)
      repository.add_location(moment, location_param)
    end
  end

  def check_locations!
    locations.each do |location_param|
      location_info = external_location_by(location_param[:address])
      if location_info.latlng
        location_param[:latlng] = location_info.latlng
      else
        @errors.push("'#{location_param[:address]}' address not found")
      end
    end
  end

  def failure?
    @errors.count.positive?
  end

  def success?
    !failure?
  end

  def nil_moment
    Moment.new(
      person_id: nil,
      year_begin: moment[:year_begin],
      year_end: moment[:year_end]
    )
  end

  def new_moment
    return unless person?

    Moment.new(
      person_id: influencer[:id],
      year_begin: moment[:year_begin],
      year_end: moment[:year_end]
    )
  end

  def external_location_by(address)
    location_service.by_address(address)
  end

  def create_influencer_if_new!
    return unless new_influencer? && person?

    person = CreatePerson.call(name: influencer[:name],
                               gender: influencer[:gender],
                               opts: { indexer: @opts[:influencer_indexer] })
    influencer[:id] = person.id.to_s
  end

  def new_influencer?
    influencer[:id].empty?
  end

  def person?
    influencer[:type] == :person
  end

  def influencer
    @influencer[:type] = @influencer[:type].to_sym
    @influencer[:id] = @influencer[:id].to_s
    @influencer
  end

  def moment
    {
      year_begin: @moment[:year_begin],
      year_end: @moment[:year_end].to_s.empty? ? nil : @moment[:year_end]
    }
  end
end
