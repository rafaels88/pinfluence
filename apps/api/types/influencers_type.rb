module Types
  InfluencersType = GraphQL::ObjectType.define do
    name 'Influencers'
    description 'Influencers splitted by their types'

    field :people, types[Types::PersonType] do
      resolve ->(obj, _args, _ctx) do
        obj.select { |i| i.type == :person }
      end
    end

    field :events, types[Types::EventType] do
      resolve ->(obj, _args, _ctx) do
        obj.select { |i| i.type == :event }
      end
    end
  end
end
