module Types
  DateType = GraphQL::ObjectType.define do
    name 'Date'

    field :date, !types.String
    field :formatted, !types.String
  end
end
