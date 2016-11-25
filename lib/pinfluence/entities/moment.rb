class Moment < Hanami::Entity
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
    LocationRepository.new
  end
end
