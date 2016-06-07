class Influencer
  include Hanami::Entity

  attributes :name, :location, :begin_at, :end_at, :level, :created_at, :updated_at
end
