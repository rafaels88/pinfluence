module Queries
  Query = GraphQL::ObjectType.define do
    name 'Moments Query'
    description 'Query root of the schema'

    field :moments do
      type !types[Types::MomentType]
      argument :influencer_name, types.String
      argument :year, types.Int
      description "Search moments by Influencer's Name"
      resolve ->(obj, args, context) {
        if args['influencer_name']
          params = { name: args['influencer_name'] }
        elsif args['year']
          params = { year: args['year'] }
        end
        SearchMoments.new(params).call
      }
    end

    field :available_years do
      type !types[Types::YearType]
      description 'All available years for searching by moments'
      resolve ->(obj, args, context) { MomentRepository.new.all_available_years }
    end
  end
end
