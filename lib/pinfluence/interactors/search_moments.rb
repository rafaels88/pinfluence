class SearchMoments
  def self.call(params)
    self.new(params).call
  end

  attr_reader :year, :name, :repository

  def initialize(year: nil, name: nil, repository: MomentRepository)
    @repository = repository
    @year = year
    @name = name
  end

  def call
    if name
      person = PersonRepository.search_by_name(name).first
      if person
        repository.search_by_influencer(person)
      else
        []
      end
    elsif year
      repository.search_by_date(year: year)
    end
  end
end
