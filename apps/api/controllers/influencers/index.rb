require 'json'

module Api::Controllers::Influencers
  class Index
    include Api::Action
    attr_reader :repository

    expose :influencers

    def initialize(repository: InfluencerRepository)
      @repository = repository.new
      @years = []
    end

    def call(params)
      self.body = JSON.generate({
        collection: collection(params),
        available_years: years
      })
    end

    private

    def collection(params)
      if params[:year]
        repository.by_date(year: params[:year]).map do |influencer|
          {
            id: influencer.id,
            name: influencer.name,
            latlng: influencer.latlng,
            begin_at: influencer.begin_at
          }
        end
      else
        []
      end
    end

    def years
      repository.all_available_years
    end
  end
end
