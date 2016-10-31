class AvailablePeople
  def self.call
    self.new.call
  end

  attr_reader :repository

  def initialize(repository: PersonRepository)
    @repository = repository
  end

  def call
    repository.all
  end
end
