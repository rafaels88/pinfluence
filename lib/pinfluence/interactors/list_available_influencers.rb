require_relative './interactor'

class ListAvailableInfluencers
  include Interactor

  attr_reader :repository
  expose :influencers

  def initialize(repository: PersonRepository.new)
    @repository = repository
  end

  def call
    @influencers = repository.all_ordered_by(:name)
  end
end
