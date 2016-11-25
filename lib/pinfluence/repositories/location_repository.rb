class LocationRepository < Hanami::Repository

  def by_moment(moment)
    locations
      .where(moment_id: moment.id)
  end
end
