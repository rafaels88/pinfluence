module Api::Views::Moments
  class Index
    include Api::View

    def render
      raw JSON.generate(data: collection)
    end

    private

    def collection
      moments.map { |moment| moment_hash(moment) }
    end

    def moment_hash(moment)
      {
        id: moment.id,
        begin_in: moment.year_begin,
        locations: locations_hash(moment.locations),
        influencer: influencer_hash(moment.influencer)
      }
    end

    def locations_hash(locations)
      locations.map do |location|
        {
          id: location.id,
          density: location.density,
          latlng: location.latlng.split(',')
        }
      end
    end

    def influencer_hash(influencer)
      {
        id: influencer.id,
        name: influencer.name,
        gender: influencer.gender.downcase,
        kind: influencer.type
      }
    end
  end
end
