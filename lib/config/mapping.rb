collection :influencers do
  entity     Influencer
  repository InfluencerRepository

  attribute :id,   Integer
  attribute :name, String
  attribute :location, String
  attribute :begin_at, Time
  attribute :end_at, Time
  attribute :level, Integer
  attribute :created_at, Time
  attribute :updated_at, Time
end
