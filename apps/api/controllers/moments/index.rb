require_relative './search_params'

module Api::Controllers::Moments
  class Index
    include Api::Action
    params SearchParams
    expose :moments
    expose :searched_year

    def call(params)
      if params.valid?
        @searched_year = params[:year].to_i if params[:year]
        @moments = SearchMoments.call(params)
      else
        status 400, 'You should especify at least one search param'
      end
    end
  end
end
