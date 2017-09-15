module Schemas
  Schema = GraphQL::Schema.define do
    query Queries::Query
  end
end
