module Influencers
  class Indexer
    attr_reader :influencers, :index_object_class

    def initialize(influencers: [], index_object:)
      @influencers = influencers
      @index_object_class = index_object
    end

    def save
      index_object_hashes = influencers.map do |influencer|
        index_object = index_object_class.new influencer
        index_object.to_hash
      end

      index.add_objects(index_object_hashes)
    end

    def delete
      index.delete_objects(influencers.map(&:id))
    end

    def clear!
      index.clear_index
    end

    private

    def index
      @index ||= Algolia::Index.new(index_object_class::SEARCH_INDEX_NAME)
    end
  end
end
