require_relative '../../interactors/interactor'

module Influencers
  class SearchQuery
    include Interactor

    LIMIT_OF_RESULTS = 7

    attr_reader :name, :limit

    def initialize(name:, limit: LIMIT_OF_RESULTS)
      @name = name
      @limit = limit
    end

    def call
      search_result.map do |hit|
        symbolized = JSON.parse(hit.to_json, symbolize_names: true)
        Influencers::IndexObject.new(symbolized) if hit['kind'] == 'person'
      end.compact
    end

    private

    def search_result
      search_index.search(name)['hits']
    end

    def search_index
      @index ||= Algolia::Index.new(Influencer::SEARCH_INDEX_NAME)
    end
  end
end
