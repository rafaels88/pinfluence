module Admin::Views::Moments
  class Create
    include Admin::View
    template 'moments/new'

    def form
      Form.new(:moment, routes.moments_path, moment: moment)
    end

    def submit_label
      'Create'
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

    NilLocation = Struct.new(:id, :density, :address)
    def moment_first_location
      return @_first if @_first

      @_first ||= if moment.locations
                    moment.locations.first
                  else
                    NilLocation.new(nil, '1', '')
                  end
    end

    def locations
      # This is a workaround to make form work, until we have
      # associations support to template form
      moment_first_location
    end
  end
end
