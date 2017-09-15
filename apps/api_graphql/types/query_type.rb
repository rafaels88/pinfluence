module Queries
  MomentsQuery = GraphQL::ObjectType.define do
    name 'Moments Query'
    description 'Query root of the schema'

    field :moments do
      type Types::MomentType
      argument :id, !types.ID
      description 'Find a person by ID'
      resolve ->(obj, args, context) { MomentRepository.new.find(args['id']) }
    end

    field :available_years do
      type !types[Types::YearType]
      description 'All available years for searching by moments'
      resolve ->(obj, args, context) { MomentRepository.new.all_available_years }
    end
  end
end
