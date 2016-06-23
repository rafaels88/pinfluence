module Admin::Views::Influencers
  class Edit
    include Admin::View

    def method
      :patch
    end

    def locations
      influencer.locations
    end

    def submit_label
      'Update'
    end
  end
end
