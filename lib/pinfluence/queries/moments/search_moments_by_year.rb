require_relative '../../interactors/interactor'

module Moments
  class SearchMomentsByYear
    include Interactor

    attr_reader :year, :repository, :limit

    def initialize(year: nil, limit: 100, repository: MomentRepository.new)
      @repository = repository
      @year = year
      @limit = limit
    end

    def call
      repository.search_by_date(year: year, limit: limit)
    end
  end
end
