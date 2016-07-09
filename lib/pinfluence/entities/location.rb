class Location
  include Hanami::Entity

  attributes :name, :latlng, :influencer_id, :begin_in, :end_in, :created_at, :updated_at
end
