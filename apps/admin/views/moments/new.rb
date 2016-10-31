module Admin::Views::Moments
  class New
    include Admin::View

    def form
      Form.new(:moment, routes.moments_path)
    end

    def submit_label
      'Create'
    end
  end
end
