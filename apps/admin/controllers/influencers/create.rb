module Admin::Controllers::Influencers
  class Create
    include Admin::Action

    def call(params)
      InfluencerRepository.new.create(Influencer.new(params[:influencer]))
      redirect_to routes.influencers_path
    end
  end
end
