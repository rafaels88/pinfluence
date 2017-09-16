module Admin::Controllers::Moments
  class Index
    include Admin::Action
    expose :moments

    def call(_)
      @moments = MomentRepository.new.all_with_influencers
    end
  end
end
