module Influencers
  class Indexer
    attr_reader :influencers

    def initialize(influencers: [])
      @influencers = influencers
    end

    def save
      index_object_hashes = influencers.map do |influencer|
        index_object = IndexObject.new influencer
        index_object.to_hash
      end

      index.add_objects(index_object_hashes)
    end

    private

    def index
      @index ||= Algolia::Index.new(Influencer::SEARCH_INDEX_NAME)
    end
  end
end
