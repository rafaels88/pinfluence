module Admin::Controllers::Events
  class Update
    include Admin::Action

    def call(params)
      UpdateEvent.call(event_params(params))
      redirect_to routes.edit_event_path(id: params[:id])
    end

    private

    def event_params(params)
      Hanami::Utils::Hash.deep_symbolize(
        moments: params[:event].delete(:moments),
        event: params[:event].merge(id: params[:id])
      )
    end
  end
end
