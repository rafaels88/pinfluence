PersonType = GraphQL::ObjectType.define do
  name 'Person'
  description 'A person influencer'

  field :name, !types.String
  field :gender, !types.String
end
