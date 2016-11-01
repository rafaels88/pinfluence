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
    repository.search_by_date(year: year)
  end
end
