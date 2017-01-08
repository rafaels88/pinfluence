require_relative './interactor'

class CreatePerson
  extend Interactor

  attr_reader :name, :gender, :repository

  def initialize(name:, gender:, repository: PersonRepository.new)
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
