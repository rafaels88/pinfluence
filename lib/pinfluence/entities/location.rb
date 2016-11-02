class Location
  include Hanami::Entity
  attributes :moment_id, :address, :latlng, :density,
    :created_at, :updated_at
end
