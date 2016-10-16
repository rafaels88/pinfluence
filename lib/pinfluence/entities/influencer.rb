class Influencer
  extend Forwardable
  include Hanami::Entity

  attributes :name, :level, :gender, :created_at, :updated_at

  attr_accessor :current_locations
  attr_reader :locations

  def initialize(*args)
    super
    @current_locations = [first_location_associated]
    @locations = []
  end

  def begin_in
    first_location_associated.begin_in
  end

  def end_in
    first_location_associated.end_in
  end

  def kind
    :influencer
  end

  def location_id
    current_location.id
  end

  def locations
    location_repository.by_influencer(self)
  end

  def update_locations!(locations_params)
    locations_params.each do |loc_id, loc_params|
      location = location_repository.find(loc_id)
      location.name = loc_params[:name]
      location.begin_in = loc_params[:begin_in]
      location.end_in = loc_params[:end_in]
      location.latlng = loc_params[:latlng]
      location_repository.update(location)
    end
  end

  def add_locations!(locations_params)
    locations_params.each do |loc_params|
      location = Location.new
      location.name = loc_params[:name]
      location.begin_in = loc_params[:begin_in]
      location.end_in = loc_params[:end_in]
      location.latlng = loc_params[:latlng]
      location.influencer_id = self.id
      location_repository.create(location)
    end
  end

  def delete_locations!(locations_params)
    if !locations_params[:ids].nil?
      locations_params[:ids].each do |location_id|
        location = location_repository.find(location_id)
        location_repository.delete(location)
      end
    end
  end

  private

  def first_location_associated
    @_first_location ||= location_repository.first_location_of_influencer(self)
  end

  def location_repository
    LocationRepository
  end
end
