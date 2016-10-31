class CreateMoment
  def self.call(params)
    self.new(params).call
  end

  attr_reader :location, :influencer, :year_begin, :year_end, :repository

  def initialize(location:, influencer:, year_begin:, year_end:, repository: MomentRepository)
    @repository = repository
    @location = location
    @influencer = influencer
    @year_begin = year_begin
    @year_end = year_end
  end

  def call
    repository.create(new_moment)
  end

  private

  def new_moment
    Moment.new(
      location: location,
      latlng: latlng,
      influencer_id: influencer[:id],
      influencer_type: influencer[:type],
      year_begin: year_begin,
      year_end: year_end
    )
  end

  def latlng
    "0,0"
  end
end
