module Admin::Controllers::Moments
  class Create
    include Admin::Action

    def call(params)
      CreateMoment.call(params[:moment])
      redirect_to routes.moments_path
    end
  end
end
