module Admin::Views::Events
  class Edit
    include Admin::View

    def form
      Form.new(:event, routes.event_path(id: event.id),
               { event: event }, method: :patch)
    end

    def submit_label
      'Update'
    end
  end
end
