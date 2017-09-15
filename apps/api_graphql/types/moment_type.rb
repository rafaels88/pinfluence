module Types
  MomentType = GraphQL::ObjectType.define do
    name 'Moment'
    description 'A moment in history'

    field :year_begin, !types.String
  end
end
