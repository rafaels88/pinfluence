require_relative '../../interactors/interactor'

module Influencers
  class ListAvailableInfluencers
    include Interactor

    attr_reader :repository

    def initialize(repository: PersonRepository.new)
      @repository = repository
    end

    def call
      repository.all_ordered_by(:name)
    end
  end
end
