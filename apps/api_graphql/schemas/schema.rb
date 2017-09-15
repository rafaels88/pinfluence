module Schemas
  MomentSchema = GraphQL::Schema.define do
    query Queries::MomentsQuery
  end
end
