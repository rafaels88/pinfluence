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
      search_result.map do |result|
        result['hits'].map do |hit|
          symbolized = JSON.parse(hit.to_json, symbolize_names: true)
          factory_index_object(symbolized)
        end
      end.flatten.compact
    end

    private

    def factory_index_object(hit)
      case hit[:type]
      when 'person'
        Influencers::PersonIndexObject.new(hit)
      when 'event'
        Influencers::EventIndexObject.new(hit)
      end
    end

    def search_result
      Algolia.multiple_queries(
        [
          { index_name: PersonIndexObject::SEARCH_INDEX_NAME, query: name, hitsPerPage: limit },
          { index_name: EventIndexObject::SEARCH_INDEX_NAME, query: name, hitsPerPage: limit }
        ]
      )['results']
    end
  end
end
