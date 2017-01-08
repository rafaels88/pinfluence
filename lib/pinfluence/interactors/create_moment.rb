require_relative './interactor'

class CreateMoment
  extend Interactor

  attr_reader :locations, :year_begin, :year_end,
              :repository, :location_service

  def initialize(influencer:, locations:, year_begin:, year_end:,
                 repository: MomentRepository.new,
                 location_service: LocationService.new)
    @repository = repository
    @location_service = location_service
    @locations = locations
    @influencer = influencer
    @year_begin = year_begin
    @year_end = year_end.to_s.empty? ? nil : year_end
  end

  def call
    create_influencer_if_new!
    moment = repository.create(new_moment)
    locations.each do |location_param|
      location_param.delete(:id)
      location_info = external_location_by(location_param[:address])
      location_param[:latlng] = location_info.latlng
      repository.add_location(moment, location_param)
    end
  end

  private

  def new_moment
    if person?
      Moment.new(
        person_id: influencer[:id],
        year_begin: year_begin,
        year_end: year_end
      )
    end
  end

  def external_location_by(address)
    @_location ||= location_service.by_address(address)
  end

  def create_influencer_if_new!
    if new_influencer? && person?
      person = CreatePerson.call(name: influencer[:name],
                                 gender: influencer[:gender])
      @influencer[:id] = person.id.to_s
    end
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
end
