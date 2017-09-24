module Admin::Controllers::Moments
  class Create
    include Admin::Action
    expose :moment, :influencers

    def call(params)
      creator = CreateMoment.new(moment_params(params))
      creator.call
      redirect_to routes.moments_path if creator.errors.empty?

      prepare_for_editing(Moment.new)
      flash[:error] = creator.errors.first
    end

    private

    def prepare_for_editing(moment)
      @influencers = Influencers::ListAvailableInfluencers.call(
        repository: PersonRepository.new
      )
      @moment = moment
    end

    def moment_params(params)
      # Need to transform :locations in an array until we have a
      # nice solution, since :fields_for helper does not work for collections

      Hanami::Utils::Hash.deep_symbolize(
        locations: [params[:moment].delete(:locations)],
        influencer: params[:moment].delete(:influencer),
        moment: params[:moment]
      )
    end
  end
end
