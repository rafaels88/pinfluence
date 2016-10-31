class CreatePerson
  def self.call(params)
    self.new(params).call
  end

  attr_reader :name, :gender, :repository

  def initialize(name:, gender:, repository: PersonRepository)
    @name = name
    @gender = gender
    @repository = repository
  end

  def call
    repository.create(new_person)
  end

  private

  def new_person
    Person.new(name: name, gender: gender)
  end
end
