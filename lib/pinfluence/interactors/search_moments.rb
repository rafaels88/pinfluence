require_relative './interactor'

class SearchMoments
  include Interactor

  attr_reader :year, :name, :repository

  def initialize(year: nil, name: nil, repository: MomentRepository.new)
    @repository = repository
    @year = year
    @name = name
  end

  def call
    if name
      person = PersonRepository.new.search_by_name(name).first
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
