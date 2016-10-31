class InfluenceRepository
  def self.by_date(opts)
    influencer_repository.by_date(opts) +
      event_repository.by_date(opts)
  end

  def self.by_name(name)
    influencer_repository.by_name(name)
  end

  def self.by_latlng(lat:, lng:)
    influencer_repository.by_latlng(lat: lng, lng: lng)
  end

  def self.all_available_years
    influencer_repository.all_available_years
  end

  def self.all_ordered_by(field=:name)
    influencer_repository.all_ordered_by(field)
  end

  private

  def self.influencer_repository
    InfluencerRepository
  end

  def self.event_repository
    EventRepository
  end
end
