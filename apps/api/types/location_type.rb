module Types
  LocationType = GraphQL::ObjectType.define do
    name 'Location'
    description 'A location'

    field :id, !types.Int
    field :latlng, types[!types.String] do
      resolve ->(obj, _, _) do
        obj.latlng.split(',').map(&:to_s)
      end
    end
    field :density, !types.Int
  end
end
