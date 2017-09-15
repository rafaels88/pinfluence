module Types
  LocationType = GraphQL::ObjectType.define do
    name 'Location'
    description 'A location'

    field :id, !types.Int
    field :latlng, types[!types.String] do
      resolve ->(obj, args, ctx) {
        obj.latlng.split(',').map(&:to_s)
      }
    end
    field :density, !types.Int
  end
end
