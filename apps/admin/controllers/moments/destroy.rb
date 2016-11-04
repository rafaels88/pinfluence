module Admin::Controllers::Moments
  class Destroy
    include Admin::Action

    def call(params)
      DestroyMoment.call(params[:id])
      redirect_to routes.moments_path
    end
  end
end
