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
      location = find_or_new(location_param[:id])
      location_info = external_location_by(location_param[:address])
      location_param[:latlng] = location_info.latlng
      moment.add_location(location_param)
    end
  end

  private

  def moment
    @_moment ||= repository.find(id)
  end

  def external_location_by(address)
    @_location ||= location_service.by_address(address)
  end
end
