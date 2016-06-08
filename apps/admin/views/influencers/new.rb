module Admin::Views::Influencers
  class New
    include Admin::View

    def form
      Form.new(:influencer, routes.influencers_path)
    end

    def submit_label
      'Create'
    end
  end
end
