QueryType = GraphQL::ObjectType.define do
  name 'Query'
  description 'Query root of the schema'

  field :person do
    type PersonType
    argument :id, !types.ID
    description "Find a person by ID"
    resolve ->(obj, args, context) { PersonRepository.new.find(args['id']) }
  end
end
