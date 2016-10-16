class Event
  extend Forwardable
  include Hanami::Entity

  attributes :name, :created_at, :updated_at
  attr_accessor :current_locations

  def initialize(*args)
    super
    @current_locations = current_locations
  end

  def begin_in
    -1000
  end

  def end_in
    -900
  end

  def kind
    :influencer
  end

  def locations
    []
  end

  def current_locations
    []
  end

  def gender
    :none
  end

  private

  def location_repository
    LocationRepository
  end
end
