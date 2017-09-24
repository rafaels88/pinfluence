module Admin::Controllers::Events
  class Create
    include Admin::Action

    def call(params)
      CreateEvent.call(event_params(params))
      redirect_to routes.events_path
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
