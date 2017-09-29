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
      description 'All available years for searching by moments'
      resolve ->(_obj, _args, _ctx) { MomentRepository.new.all_available_years }
    end

    field :influencers do
      type Types::InfluencersType
      argument :name, types.String
      description 'Search influencers'
      resolve ->(_obj, args, _ctx) { Influencers::SearchQuery.call(name: args[:name]) }
    end
  end
end
