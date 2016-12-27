class CreateMoment
  def self.call(params)
    self.new(params).call
  end

  attr_reader :influencer, :locations, :year_begin, :year_end,
    :repository, :location_service

  def initialize(influencer:, locations:, year_begin:, year_end:,
                 repository: MomentRepository.new, location_service: LocationService.new, **)
    @repository = repository
    @location_service = location_service
    @locations = locations
    @influencer = influencer
    @year_begin = year_begin
    @year_end = year_end
  end

  def call
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
    if influencer[:type] == :person
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
end
