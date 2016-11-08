module Api::Controllers::Moments
  class SearchParams < Api::Action::Params
    params do
      optional(:year).maybe(:str?)
      optional(:name).maybe(:str?)

      rule(search_presence: [:year, :name]) do |year, name|
        year.none?.then(name.filled?) &
          name.none?.then(year.filled?)
      end
    end
  end
end
