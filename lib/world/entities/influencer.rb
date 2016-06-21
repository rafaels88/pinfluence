class Influencer
  extend Forwardable
  include Hanami::Entity

  attributes :name, :level, :gender, :created_at, :updated_at

  attr_accessor :current_location
  def_delegators :current_location, :begin_in, :latlng, :location, :end_in

  def initialize(*args)
    super
    @current_location = first_location_associated
  end

  private

  def first_location_associated
    location_repository.first_location_of_influencer(self)
  end

  def location_repository
    LocationRepository
  end
end
