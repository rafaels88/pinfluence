module Web::Controllers::Home
  class Index
    include Web::Action

    expose :gmaps_api_key

    def call(params)
      @gmaps_api_key = ENV['GOOGLE_MAPS_API_KEY']
    end
  end
end
