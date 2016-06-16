module Admin::Controllers::Influencers
  class Update
    include Admin::Action

    def call(params)
      influencer = repository.find(params[:id])
      influencer.update(influencer_params)
      repository.persist(influencer)

      redirect_to routes.influencers_path
    end

    private

    def influencer_params
      params[:influencer].merge({
        'latlng' => latlng_for(params[:influencer]['location'])
      })
    end

    def latlng_for(location)
      req = HTTParty.get(URI.escape("http://nominatim.openstreetmap.org/search/#{location}?format=json"))
      response = JSON.parse(req.body).first
      uniq_latlng = change_for_unique_latlng({
        lat: response['lat'],
        lng: response['lon']
      })
      "#{uniq_latlng[:lat]}, #{uniq_latlng[:lng]}"
    end

    def change_for_unique_latlng(latlng_to_uniquify)
      unique_latlng_candidate = {
        lat: generate_random_near_location_number(latlng_to_uniquify[:lat]),
        lng: generate_random_near_location_number(latlng_to_uniquify[:lng])
      }

      result = repository.by_latlng(lat: unique_latlng_candidate[:lat], lng: unique_latlng_candidate[:lng])
      if result.count > 0
        change_for_unique_latlng(unique_latlng_candidate)
      else
        unique_latlng_candidate
      end
    end

    def generate_random_near_location_number(number)
      number_splitted = number.to_s.split("")
      dot_index = number_splitted.index(".")
      first_to_increase = number_splitted[dot_index + 2].to_i
      second_to_increase = number_splitted[dot_index + 3].to_i

      first_new_number = (first_to_increase + 1) == 10 ? 0 : first_to_increase + 2
      second_new_number = (second_to_increase + 1) == 10 ? 0 : second_to_increase + 2

      number_splitted[dot_index + 2] = first_new_number.to_s
      number_splitted[dot_index + 3] = second_new_number.to_s
      number_splitted.join.to_f
    end

    def repository
      InfluencerRepository
    end
  end
end
