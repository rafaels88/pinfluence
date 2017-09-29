module Moments
  class PersistLocations
    include Interactor

    attr_reader :moment, :locations_params, :repository, :moment_repository, :service

    def initialize(moment:, locations:, opts: {})
      @moment = moment
      @locations_params = locations

      @service = opts.fetch(:location_service, Locations::Searcher.new)
      @repository = opts.fetch(:location_repository, LocationRepository.new)
    end

    def call
      locations_params.each do |params|
        if params[:id].to_s.empty?
          create(persist_params(params))
        else
          update(persist_params(params))
        end
      end
    end

    private

    def update(params)
      location_id = params.delete(:id)
      repository.update(location_id, params)
    end

    def create(params)
      params.delete(:id)
      repository.create(params)
    end

    def persist_params(params)
      info = service.by_address(params[:address])
      params.merge(moment_id: moment.id, latlng: info.latlng)
    end
  end
end
