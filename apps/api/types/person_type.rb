module Types
  PersonType = GraphQL::ObjectType.define do
    name 'Person'
    description 'A person'

    field :id, !types.Int
    field :name, !types.String
    field :gender, !types.String
    field :type, !types.String
    field :earliest_date, types.String
  end
end
