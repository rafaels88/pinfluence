module Types
  EventType = GraphQL::ObjectType.define do
    name 'Event'
    description 'A event'

    field :id, !types.Int
    field :name, !types.String
    field :type, !types.String
    field :earliest_year, types.Int
  end
end
