class Influencer
  include Hanami::Entity

  attributes :name, :level, :location, :begin_at, :end_at, :latlng, :gender, :created_at, :updated_at
end
