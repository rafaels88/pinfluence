module Admin::Controllers::Moments
  class Index
    include Admin::Action
    expose :moments

    def call(params)
      @moments = MomentRepository.new.all
    end
  end
end
