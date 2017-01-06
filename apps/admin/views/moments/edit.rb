module Admin::Views::Moments
  class Edit
    include Admin::View

    def form
      Form.new(:moment, routes.moment_path(id: moment.id),
               { moment: moment }, method: :patch)
    end

    def submit_label
      'Update'
    end

    def person_id
      moment.person_id.to_s
    end

    def first_location_density
      moment_first_location.density.to_i
    end

    InfluencerOption = Struct.new(:name, :id)
    def influencers_options
      nil_option = InfluencerOption.new('Click here to choose', nil)
      influencers.unshift(nil_option)
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
