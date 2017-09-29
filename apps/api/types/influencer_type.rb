module Types
  InfluencerType = GraphQL::ObjectType.define do
    name 'Influencer'
    description 'A generic interface for an influencer'

    field :id, !types.Int
    field :name, !types.String
    field :gender, types.String do
      resolve ->(obj, _args, _ctx) do
        return nil unless obj.respond_to? :gender
        obj.gender
      end
    end
    field :type, !types.String
    field :earliest_year, types.Int
  end
end
