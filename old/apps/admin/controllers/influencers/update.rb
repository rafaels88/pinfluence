module Admin::Controllers::Influencers
  class Update
    include Admin::Action

    def call(params)
      influencer = repository.find(params[:id])
      influencer.update(influencer_params)
      influencer.update_locations!(locations_params)
      influencer.add_locations!(new_locations_params)
      influencer.delete_locations!(excluded_locations_params)
      repository.update(influencer)

      redirect_to routes.influencers_path
    end

    private

    def new_locations_params
      if params[:influencer]["new_locations"]
        params[:influencer]["new_locations"].map do |location_params|
          if !location_params["name"].empty? && !location_params["begin_in"].empty?
            {
              name: location_params['name'],
              begin_in: location_params['begin_in'],
              end_in: location_params['end_in'],
              latlng: latlng_for(location_params['name'])
            }
          end
        end.compact
      else
        []
      end
    end

    def locations_params
      @_locations = {}
      if params[:influencer]["locations"]
        params[:influencer]["locations"].each do |location_id, location_params|
          @_locations[location_id] = {
            name: location_params['name'],
            begin_in: location_params['begin_in'],
            end_in: location_params['end_in'],
            latlng: latlng_for(location_params['name'], location_id: location_id)
          }
        end
      end
      @_locations
    end

    def excluded_locations_params
      { ids: params[:influencer]['excluded_locations'] }
    end

    def influencer_params
      {
        name: params[:influencer]['name'],
        gender: params[:influencer]['gender'],
        level: params[:influencer]['level']
      }
    end

    def latlng_for(location_name, location_id: nil)
      if location_id
        location = location_repository.find(location_id)
        if location && location.name == location_name
          return location.latlng
        end
      end

      req = HTTParty.get(URI.escape("http://nominatim.openstreetmap.org/search/#{location_name}?format=json"))
      response = JSON.parse(req.body).first

      latlng = {
        lat: response['lat'],
        lng: response['lon']
      }

      unless is_latlng_unique?(latlng)
        latlng = change_for_unique_latlng({
          lat: response['lat'],
          lng: response['lon']
        })
      end

      "#{latlng[:lat]}, #{latlng[:lng]}"
    end

    def is_latlng_unique?(latlng)
      result = repository.by_latlng(lat: latlng[:lat], lng: latlng[:lng])
      result.count == 0 ? true : false
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

    def location_repository
      LocationRepository
    end
  end
end
