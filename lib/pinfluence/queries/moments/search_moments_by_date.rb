require_relative '../../interactors/interactor'

module Moments
  class SearchMomentsByDate
    include Interactor

    attr_reader :date, :repository, :limit

    def initialize(date: nil, limit: 100, repository: MomentRepository.new)
      @repository = repository
      @date = date
      @limit = limit
    end

    def call
      repository.search_by_date(date: date, limit: limit)
    end
  end
end
