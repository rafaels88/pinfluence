module Admin::Views::Moments
  class New
    include Admin::View

    def form
      Form.new(:moment, routes.moments_path)
    end

    def submit_label
      'Create'
    end

    def first_location_density; end

    def first_location_address; end

    def first_location_id; end
  end
end
