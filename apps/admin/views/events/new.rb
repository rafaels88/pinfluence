module Admin::Views::Events
  class New
    include Admin::View

    def form
      Form.new(:event, routes.events_path, event: event)
    end

    def submit_label
      'Create'
    end
  end
end
