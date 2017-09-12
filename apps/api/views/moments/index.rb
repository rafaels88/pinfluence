module Api::Views::Moments
  class Index
    include Api::View

    def render
      raw JSON.generate(collection: collection)
    end

    private

    def collection
      moments.map { |moment| moment_hash(moment) }
    end

    def moment_hash(moment)
      {
        id: moment.influencer.id,
        name: moment.influencer.name,
        gender: moment.influencer.gender.to_s.downcase,
        begin_in: moment.year_begin,
        kind: moment.influencer.type,
        age: moment_age(moment),
        locations: locations_hash_by_moment(moment)
      }
    end

    def locations_hash_by_moment(moment)
      moment.locations.map do |location|
        {
          id: location.id,
          density: location.density,
          latlng: location.latlng.split(',')
        }
      end
    end

    def moment_age(moment)
      searched_year - moment.year_begin if searched_year
    end
  end
end
