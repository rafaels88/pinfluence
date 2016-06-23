class Influencer
  extend Forwardable
  include Hanami::Entity

  attributes :name, :level, :gender, :created_at, :updated_at
  def_delegators :current_location, :begin_in, :latlng, :location, :end_in

  attr_accessor :current_location

  def initialize(*args)
    super
    @current_location = first_location_associated
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

  private

  def first_location_associated
    location_repository.first_location_of_influencer(self)
  end

  def location_repository
    LocationRepository
  end
end
