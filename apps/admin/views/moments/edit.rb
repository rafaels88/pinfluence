module Admin::Views::Moments
  class Edit
    include Admin::View

    def form
      Form.new(:moment, routes.moment_path(id: moment.id),
               { moment: moment, locations: locations }, { method: :patch })
    end

    def submit_label
      'Update'
    end

    private

    def locations
      # This is a workaround to make form work, until we have
      # associations support to template form
      moment.locations.first
    end
  end
end
