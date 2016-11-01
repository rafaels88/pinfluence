module Api::Controllers::Moments
  class SearchParams < Api::Action::Params
    params do
      required(:year).filled(:str?)
    end
  end
end
