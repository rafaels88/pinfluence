module Admin::Controllers::Influencers
  class Create
    include Admin::Action

    def call(params)
      influencer = Influencer.new(influencer_params)
      repository.create(influencer)

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
      "#{response['lat']}, #{response['lon']}"
    end

    def repository
      InfluencerRepository.new
    end
  end
end
