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
      body = {
        collection: collection(params),
      }

      body[:available_years] = years if body[:collection].empty?

      self.body = JSON.generate(body)
    end

    private

    def collection(params)
      if params[:year]
        repository.by_date(year: params[:year]).map { |i| build_influencer_body(i) }

      elsif params[:name]
        influencer = repository.by_name(params[:name])
        if influencer
          [build_influencer_body(influencer)]
        else
          []
        end

      else
        []
      end
    end

    def build_influencer_body(influencer)
      if influencer
        {
          id: influencer.id,
          name: influencer.name,
          latlng: influencer.latlng,
          begin_at: influencer.begin_at
        }
      end
    end

    def years
      repository.all_available_years
    end
  end
end
