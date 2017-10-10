module Moments
  module Concerns
    module Persister
      attr_reader :moment_params, :locations_params, :influencer_params, :repository, :person_repository,
                  :errors, :location_service, :opts

      class LocationAddressNotFound < StandardError; end

      def clean_empty_locations!
        locations_params.each do |location_param|
          locations_params.delete(location_param) if location_param[:address].to_s.empty?
        end
      end

      def check_locations!
        locations_params.each do |location_param|
          location_info = location_service.by_address(location_param[:address])

          raise LocationAddressNotFound, "'#{location_param[:address]}' address not found" unless location_info.latlng

          location_param[:latlng] = location_info.latlng
        end
      end

      def persist_locations(moment)
        Moments::PersistLocations.call(moment: moment, locations: locations_params, opts: opts)
      end

      def update_influencer_earliest_moment(influencer)
        Influencers::UpdateEarliestMoment.call influencer: influencer, opts: opts
      end

      def find_influencer
        return if influencer_params[:id].to_s.empty?
        Influencers::Find.call(id: influencer_params[:id], type: influencer_params[:type])
      end

      def create_influencer
        Influencers::PersistInfluencer.call(
          influencer: influencer_params,
          opts: opts
        )
      end

      def normalized_date_begin
        postgres_bc_date_transform(moment_params[:date_begin])
      end

      def normalized_date_end
        moment_params[:date_end].to_s.empty? ? nil : postgres_bc_date_transform(moment_params[:date_end])
      end

      def postgres_bc_date_transform(date_value)
        return date_value unless date_value[0] == '-'
        "#{date_value[1..-1]} BC"
      end
    end
  end
end
