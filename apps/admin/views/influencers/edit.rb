module Admin::Views::Influencers
  class Edit
    include Admin::View

    def form
      Form.new(:influencer, routes.influencer_path(id: influencer.id),
        { influencer: influencer }, { method: :patch })
    end

    def submit_label
      'Update'
    end
  end
end
