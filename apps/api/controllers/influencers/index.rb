require 'json'

module Api::Controllers::Influencers
  class Index
    include Api::Action
    attr_reader :repository

    expose :influencers

    def initialize(repository: InfluencerRepository)
      @repository = repository
      @years = []
    end

    def call(params)
      body = {
        collection: collection(params),
      }

      if body[:collection].empty?
        body[:available_years] = years
        body[:available_years_formatted] = formatted_years
      end

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

    def formatted_years
      years.map do |y|
        if y < 0
          y *= -1
          "#{y} AC"
        elsif y > 0
          "#{y} DC"
        else
          y
        end
      end
    end
  end
end
