collection :influencers do
  entity     Influencer
  repository InfluencerRepository

  attribute :id,   Integer
  attribute :name, String
  attribute :location, String
  attribute :latlng, LatLng
  attribute :begin_at, Integer
  attribute :end_at, Integer
  attribute :level, Integer
  attribute :created_at, Time
  attribute :updated_at, Time
end

collection :influencers do
  entity     User
  repository UserRepository

  attribute :id,   Integer
  attribute :name, String
  attribute :email, String
  attribute :name, String
  attribute :password, String
  attribute :created_at, Time
  attribute :updated_at, Time
end
