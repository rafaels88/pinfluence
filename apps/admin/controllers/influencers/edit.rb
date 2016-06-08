module Admin::Controllers::Influencers
  class Edit
    include Hanami::Action

    expose :influencer

    def call(params)
      @influencer = repository.find(params[:id])
    end

    private

    def repository
      InfluencerRepository.new
    end
  end
end
