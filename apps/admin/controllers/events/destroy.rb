module Admin::Controllers::Events
  class Destroy
    include Admin::Action

    def call(params)
      DestroyEvent.call(params[:id])
      redirect_to routes.events_path
    end
  end
end
