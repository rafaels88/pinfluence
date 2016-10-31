class Moment
  include Hanami::Entity
  attributes :location, :latlng, :influencer_id, :influencer_type,
             :year_begin, :year_end, :created_at, :updated_at

  def spaces
    [
      OpenStruct.new({
        location: location,
        latlng: latlng,
        density: 1,
        id: 1
      })
    ]
  end

  def influencer
    @_influencer ||= Object.const_get("#{influencer_type}Repository")
      .find(influencer_id)
  end
end
