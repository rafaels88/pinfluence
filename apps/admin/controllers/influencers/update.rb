module Admin::Controllers::Influencers
  class Update
    include Admin::Action

    def call(params)
      influencer = repository.find(params[:id])
      influencer.update(params[:influencer])
      repository.persist(influencer)

      redirect_to routes.influencers_path
    end

    private

    def repository
      InfluencerRepository.new
    end
  end
end
