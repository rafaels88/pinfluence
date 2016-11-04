class UpdatePerson
  def self.call(params)
    self.new(params).call
  end

  attr_reader :id, :name, :gender, :repository

  def initialize(id:, name:, gender:, repository: PersonRepository)
    @id = id
    @name = name
    @gender = gender
    @repository = repository
  end

  def call
    repository.update(changed_person)
  end

  private

  def changed_person
    person.name = name
    person.gender = gender
    person
  end

  def person
    @_person ||= repository.find(id)
  end
end
