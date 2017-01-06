module Admin::Views::Moments
  class New
    include Admin::View

    def form
      Form.new(:moment, routes.moments_path)
    end

    def submit_label
      'Create'
    end

    def person_id; end

    InfluencerOption = Struct.new(:name, :id)
    def influencers_options
      nil_option = InfluencerOption.new('Click here to choose', nil)
      influencers.unshift(nil_option)
    end

    def first_location_density; end

    def first_location_address; end

    def first_location_id; end
  end
end
