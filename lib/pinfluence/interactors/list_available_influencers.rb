class ListAvailableInfluencers
  def self.call(params)
    self.new(params).call
  end

  attr_reader :repository

  def initialize(repository: PersonRepository)
    @repository = repository
  end

  def call
    repository.all_ordered_by(:name)
  end
end
