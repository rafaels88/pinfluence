class UpdatePerson
  def self.call(params)
    self.new(params).call
  end

  attr_reader :id, :name, :gender, :repository

  def initialize(id:, name:, gender:, repository: PersonRepository.new)
    @id = id
    @name = name
    @gender = gender
    @repository = repository
  end

  def call
    repository.update(id, **changed_person)
  end

  private

  def changed_person
    { name: name, gender: gender }
  end
end
