require_relative './interactor'

class UpdateMoment
  include Interactor

  attr_reader :id, :locations, :year_begin, :year_end,
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
    create_influencer_if_new!
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
    if person?
      {
        year_begin: year_begin,
        year_end: year_end,
        person_id: influencer[:id]
      }
    end
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

  def moment
    @_moment ||= repository.find(id)
  end

  def external_location_by(address)
    @_location ||= location_service.by_address(address)
  end

  def location_persist_params(params, info)
    params.merge(moment_id: moment.id, latlng: info.latlng)
  end

  def influencer
    @influencer[:type] = @influencer[:type].to_sym
    @influencer[:id] = @influencer[:id].to_s
    @influencer
  end
end
