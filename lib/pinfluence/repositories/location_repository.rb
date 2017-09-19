class LocationRepository < Hanami::Repository
  def by_moment(moment)
    locations
      .where(moment_id: moment.id)
      .call
      .collection
  end
end
