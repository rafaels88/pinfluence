require 'json'

module Api::Controllers::Moments
  class Index
    include Api::Action

    def call(params)
      result = SearchMoments.call(year: params[:year])
      self.body = JSON.generate({ collection: result })
    end
  end
end
