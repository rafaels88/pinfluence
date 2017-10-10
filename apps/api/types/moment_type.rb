module Types
  MomentType = GraphQL::ObjectType.define do
    name 'Moment'
    description 'A moment in history'

    field :id, types.Int
    field :date_begin, types.String
    field :locations, types[Types::LocationType]
    field :influencer, Types::InfluencerType
  end
end
