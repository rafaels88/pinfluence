class Moment
  include Hanami::Entity
  attributes :influencer_id, :influencer_type,
             :year_begin, :year_end, :created_at, :updated_at

  def locations
    location_repository.by_moment(self)
  end

  def influencer
    @_influencer ||= Object.const_get("#{influencer_type}Repository")
      .find(influencer_id)
  end

  def add_location(location)
    location.moment_id = self.id
    location_repository.create(location)
  end

  private

  def location_repository
    LocationRepository
  end
end
