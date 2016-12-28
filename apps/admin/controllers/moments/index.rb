module Admin::Controllers::Moments
  class Index
    include Admin::Action
    expose :moments

    def call(params)
      @moments = MomentRepository.new.all_with_influencers
    end
  end
end
