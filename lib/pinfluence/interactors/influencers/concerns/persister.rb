module Influencers
  module Concerns
    module Persister
      attr_reader :influencer_params, :moments_params, :influencer_repository, :indexer,
                  :index_object, :moment_repository, :opts

      private

      def reloaded_influencer(id)
        @_reloaded ||= influencer_repository.find id
      end

      def persist_index(influencer)
        indexer.new(influencers: [influencer], index_object: index_object).save
      end

      def persist_moments_for(influencer)
        moments_params.each do |moment_params|
          Moments::PersistMoment.call(
            influencer: { id: influencer.id, type: influencer.type },
            locations: moment_params.delete(:locations) || [],
            moment: moment_params,
            opts: opts
          )
        end
      end

      def persist_influencer_params
        influencer_params.select { |k, v| self.class::INFLUENCER_PARAMS_WHITELIST.include?(k) && !v.nil? }
      end
    end
  end
end
