require_relative './interactor'

class SearchMoments
  include Interactor

  attr_reader :year, :name, :repository, :limit

  def initialize(year: nil, name: nil, limit: 100, repository: MomentRepository.new)
    @repository = repository
    @year = year
    @name = name
    @limit = limit
  end

  def call
    if name
      person = PersonRepository.new.search_by_name(name).first
      if person
        repository.search_by_influencer(person, limit: limit)
      else
        []
      end
    elsif year
      repository.search_by_date(year: year, limit: limit)
    end
  end
end
