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

    def first_location_density
      moment_first_location.density.to_i
    end

    def first_location_address
      moment_first_location.address
    end

    def first_location_id
      moment_first_location.id
    end

    private

    def moment_first_location
      @_first ||= moment.locations.first
    end

    def locations
      # This is a workaround to make form work, until we have
      # associations support to template form
      moment_first_location
    end
  end
end
