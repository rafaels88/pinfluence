module Types
  YearType = GraphQL::ObjectType.define do
    name 'Year'

    field :year, !types.Int
    field :formatted, !types.String
  end
end
