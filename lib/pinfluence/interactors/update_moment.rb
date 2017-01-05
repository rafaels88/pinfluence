class UpdateMoment
  def self.call(params)
    new(params).call
  end

  attr_reader :id, :influencer, :locations, :year_begin, :year_end,
              :repository, :location_repository, :location_service

  def initialize(id:, influencer:, locations:, year_begin:, year_end:,
                 repository: MomentRepository.new,
                 location_service: LocationService.new,
                 location_repository: LocationRepository.new)
    @repository = repository
    @location_repository = location_repository
    @location_service = location_service
    @locations = locations
    @influencer = influencer
    @year_begin = year_begin
    @year_end = year_end.to_s.empty? ? nil : year_end
    @id = id
  end

  def call
    repository.update(id, changed_moment)

    locations.each do |location_params|
      location_info = external_location_by(location_params[:address])
      location_persist_params = location_persist_params(location_params,
                                                        location_info)

      if location_persist_params[:id]
        location_id = location_persist_params.delete(:id)
        location_repository.update(location_id, location_persist_params)
      else
        location_persist_params.delete(:id)
        location_repository.create(location_persist_params)
      end
    end
  end

  private

  def changed_moment
    if influencer[:type].to_sym == :person
      {
        year_begin: year_begin,
        year_end: year_end,
        person_id: influencer[:id]
      }
    end
  end

  def moment
    @_moment ||= repository.find(id)
  end

  def external_location_by(address)
    @_location ||= location_service.by_address(address)
  end

  def location_persist_params(params, info)
    params.merge(moment_id: moment.id, latlng: info.latlng)
  end
end
