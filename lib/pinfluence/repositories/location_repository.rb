class LocationRepository
  include Hanami::Repository

  def self.by_moment(moment)
    query do
      where(moment_id: moment.id)
    end
  end
end
