module Admin::Controllers::Moments
  class Edit
    include Admin::Action
    expose :influencers
    expose :moment

    def call(params)
      @influencers = influencers
      @moment = MomentRepository.find(params[:id])
    end

    private

    def influencers
      PersonRepository.all
    end
  end
end
