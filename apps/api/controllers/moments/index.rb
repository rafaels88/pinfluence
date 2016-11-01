require_relative './search_params'

module Api::Controllers::Moments
  class Index
    include Api::Action
    params SearchParams
    expose :moments

    def call(params)
      if params.valid?
        @moments = SearchMoments.call(year: params[:year])
      else
        status 400, "You should especify at least one search param"
      end
    end
  end
end
