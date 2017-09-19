module Influencers
  class IndexObject
    extend Forwardable
    attr_reader :influencer, :moment_repository
    def_delegators :influencer, :id, :name, :gender, :type

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
        'kind' => kind,
        'earliest_year_in' => earliest_year_in
      }
    end

    def kind
      @_kind ||= influencer.type
    end

    def earliest_year_in
      @_earliest_year_in ||= moment_repository.earliest_moment_of_an_influencer(influencer)&.year_begin
    end

    private

    def to_object(influencer)
      return influencer if influencer.respond_to? :id
      @_earliest_year_in = influencer[:earliest_year_in]
      influencer_class_by_string(influencer[:kind]).new influencer
    end

    def influencer_class_by_string(string)
      string.camelize.constantize
    end
  end
end
