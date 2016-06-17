class Influencer
  include Hanami::Entity

  attributes :name, :location, :latlng, :begin_at, :end_at, :level, :gender, :created_at, :updated_at
end
