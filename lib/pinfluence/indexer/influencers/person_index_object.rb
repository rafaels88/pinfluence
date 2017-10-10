module Influencers
  class PersonIndexObject
    extend Forwardable
    attr_reader :influencer, :moment_repository
    def_delegators :influencer, :id, :name, :gender, :type, :earliest_date

    SEARCH_INDEX_NAME = 'people'.freeze
    SEARCHABLE_ATTRIBUTES = ['name'].freeze

    def initialize(influencer, opts: {})
      @influencer = to_object(influencer)
      @moment_repository = opts[:moment_repository] || MomentRepository.new
    end

    def to_hash
      return @_hash unless @_hash.nil?

      @_hash = {
        'objectID' => influencer.id,
        'id' => influencer.id,
        'name' => influencer.name,
        'gender' => influencer.gender,
        'type' => influencer.type,
        'earliest_date' => influencer.earliest_date
      }
    end

    private

    def to_object(influencer)
      return influencer if influencer.respond_to? :id
      influencer_class_by_string(influencer[:type]).new influencer
    end

    def influencer_class_by_string(string)
      string.camelize.constantize
    end
  end
end
