module Api::Views::Moments
  class Index
    include Api::View

    def render
      raw JSON.generate({ collection: collection })
    end

    private

    def collection
      moments.map do |moment|
        {
          id: moment.influencer.id,
          name: moment.influencer.name,
          gender: moment.influencer.gender.downcase,
          begin_in: moment.year_begin,
          kind: moment.influencer_type.downcase,
          locations: moment.locations.map do |location|
            {
              id: location.id,
              density: location.density,
              latlng: location.latlng.split(",")
            }
          end
        }
      end
    end
  end
end
