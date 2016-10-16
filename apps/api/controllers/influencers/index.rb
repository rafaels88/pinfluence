require 'json'

module Api::Controllers::Influencers
  class Index
    include Api::Action
    attr_reader :repository

    expose :influencers

    def initialize(repository: InfluenceRepository)
      @repository = repository
      @years = []
    end

    def call(params)
      body = { collection: collection(params) }

      if body[:collection].empty?
        body[:available_years] = years
        body[:available_years_formatted] = formatted_years
      end

      self.body = JSON.generate(body)
    end

    private

    def collection(params)
      influences = []

      if params[:year]
        influences = repository.by_date(year: params[:year]).map do |i|
          build_influence_body(i)
        end

      elsif params[:name]
        influence = repository.by_name(params[:name])
        influences = [build_influence_body(influence)] if influence
      end

      influences
    end

    def build_influence_body(influence)
      {
        id: influence.id,
        name: influence.name,
        gender: influence.gender,
        begin_in: influence.begin_in,
        kind: influence.kind,
        locations: build_location_bodies(influence.current_locations)
      }
    end

    def build_location_bodies(locations)
      locations.map do |location|
        {
          id: location.id,
          density: location.density,
          latlng: location.latlng
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
