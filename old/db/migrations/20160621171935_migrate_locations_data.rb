Hanami::Model.migration do
  up do
    InfluencerRepository.all.each do |influencer|
      location = Location.new(
        name: influencer.location,
        latlng: influencer.latlng,
        begin_in: influencer.begin_at,
        end_in: influencer.end_at,
        influencer_id: influencer.id
      )

      LocationRepository.create(location)
    end
  end

  down do

  end
end
