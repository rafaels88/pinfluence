module Admin::Views::Influencers
  class New
    include Admin::View

    def method
      :post
    end

    def locations
      []
    end

    def submit_label
      'Create'
    end
  end
end
