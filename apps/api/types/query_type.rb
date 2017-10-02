module Queries
  Query = GraphQL::ObjectType.define do
    name 'Moments Query'
    description 'Query root of the schema'

    field :moments do
      type !types[Types::MomentType]
      argument :year, types.Int
      argument :limit, types.Int, default_value: 100
      description "Search moments by Influencer's Name or Year"
      resolve ->(_obj, args, _ctx) do
        Moments::SearchMomentsByYear.new(limit: args[:limit], year: args[:year]).call
      end
    end

    field :available_years do
      type !types[Types::YearType]
      argument :influencer_id, types.Int
      argument :influencer_type, types.String
      description 'All available years for searching by moments'
      resolve ->(_obj, args, _ctx) do
        if args[:influencer_id].to_s.empty? || args[:influencer_type].to_s.empty?
          return MomentRepository.new.all_available_years
        end

        Moments::ListAvailableYearsForInfluencer.call(
          influencer: { id: args[:influencer_id], type: args[:influencer_type] }
        )
      end
    end

    field :influencers do
      type Types::InfluencersType
      argument :name, types.String
      description 'Search influencers'
      resolve ->(_obj, args, _ctx) { Influencers::SearchQuery.call(name: args[:name]) }
    end
  end
end
