class InfluencerRepository
  include Hanami::Repository

  def self.by_date(opts)
    locations = location_repository.by_date(opts)
    locations.map do |location|
      influencer = find(location.influencer_id)
      influencer.add_location location
      influencer
    end
  end

  def self.by_name(name)
    query do
      where("lower(name) = '#{name.downcase}'")
    end.first
  end

  def self.by_latlng(lat:, lng:)
    locations = location_repository.by_latlng(lat: lat, lng: lng)
    locations.map do |location|
      influencer = find(location.influencer_id)
      influencer.add_location location
      influencer
    end
  end

  def self.all_available_years
    location_repository.all_available_years
  end

  def self.all_ordered_by(field=:name)
    query do
      order(field)
    end
  end

  private

  def self.location_repository
    LocationRepository
  end
end
