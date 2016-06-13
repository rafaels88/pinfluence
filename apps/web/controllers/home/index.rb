module Web::Controllers::Home
  class Index
    include Web::Action

    expose :influencers
    expose :gmaps_api_key

    def call(params)
      @influencers = repository.all
      @gmaps_api_key = ENV['GOOGLE_MAPS_API_KEY']
    end

    private

    def repository
      InfluencerRepository.new
    end
  end
end
