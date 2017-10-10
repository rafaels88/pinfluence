module Queries
  Query = GraphQL::ObjectType.define do
    name 'Moments Query'
    description 'Query root of the schema'

    field :moments do
      type !types[Types::MomentType]
      argument :date, types.String
      argument :limit, types.Int, default_value: 100
      description "Search moments by Influencer's Name or Date"
      resolve ->(_obj, args, _ctx) do
        Moments::SearchMomentsByDate.new(limit: args[:limit], date: args[:date]).call
      end
    end

    field :influencers do
      type Types::InfluencersType
      argument :name, types.String
      description 'Search influencers'
      resolve ->(_obj, args, _ctx) { Influencers::SearchQuery.call(name: args[:name]) }
    end

    field :available_dates do
      type !types[Types::DateType]
      argument :influencer_id, types.Int
      argument :influencer_type, types.String
      description 'All available dates of found moments'
      resolve ->(_obj, args, _ctx) do
        if args[:influencer_id].to_s.empty? || args[:influencer_type].to_s.empty?
          return Moments::ListAvailableDatesInSystem.call
        end

        Moments::ListAvailableDatesForInfluencer.call(
          influencer: { id: args[:influencer_id], type: args[:influencer_type] }
        )
      end
    end
  end
end
