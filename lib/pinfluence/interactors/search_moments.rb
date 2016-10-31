class SearchMoments
  def self.call(params)
    self.new(params).call
  end

  attr_reader :year, :repository

  def initialize(year:, repository: MomentRepository)
    @repository = repository
    @year = year
  end

  def call
    repository.search_by_date(year: year).map do |moment|
      {
        id: moment.influencer.id,
        name: moment.influencer.name,
        gender: moment.influencer.gender,
        begin_in: moment.year_begin,
        kind: moment.influencer_type,
        locations: moment.spaces.map do |space|
          {
            id: space.id,
            density: space.density,
            latlng: space.latlng
          }
        end
      }
    end
  end
end
