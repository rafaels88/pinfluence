collection :influencers do
  entity     Influencer
  repository InfluencerRepository

  attribute :id,   Integer
  attribute :name, String
  attribute :level, Integer
  attribute :gender, String
  attribute :created_at, Time
  attribute :updated_at, Time
end

collection :users do
  entity     User
  repository UserRepository

  attribute :id,   Integer
  attribute :name, String
  attribute :email, String
  attribute :name, String
  attribute :password, Password
  attribute :created_at, Time
  attribute :updated_at, Time
end

collection :locations do
  entity     Location
  repository LocationRepository

  attribute :id,   Integer
  attribute :name, String
  attribute :latlng, String
  attribute :begin_in, Integer
  attribute :end_in, Integer
  attribute :influencer_id, Integer
  attribute :created_at, Time
  attribute :updated_at, Time
end
