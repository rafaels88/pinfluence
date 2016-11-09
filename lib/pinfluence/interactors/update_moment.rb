class UpdateMoment
  def self.call(params)
    self.new(params).call
  end

  attr_reader :id, :influencer, :locations, :year_begin, :year_end,
    :repository, :location_service

  def initialize(id:, influencer:, locations:, year_begin:, year_end:,
                 repository: MomentRepository, location_service: LocationService.new)
    @repository = repository
    @location_service = location_service
    @locations = locations
    @influencer = influencer
    @year_begin = year_begin
    @year_end = year_end
    @id = id
  end

  def call
    repository.update(changed_moment)

    locations.each do |location_param|
      location = find_or_new_location(location_param[:id])
      location_info = external_location_by(location_param[:address])

      location.address = location_param[:address]
      location.latlng = location_info.latlng
      location.density = location_param[:density]
      moment.add_location(location)
    end
  end

  private

  def changed_moment
    moment.year_begin = year_begin
    moment.year_end = year_end
    moment.influencer_type = influencer[:type]
    moment.influencer_id = influencer[:id]
    moment
  end

  def moment
    @_moment ||= repository.find(id)
  end

  def external_location_by(address)
    @_location ||= location_service.by_address(address)
  end

  def find_or_new_location(id)
    LocationRepository.find(id) || Location.new(moment_id: moment.id)
  end
end
