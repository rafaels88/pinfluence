require_relative './interactor'

class DestroyPerson
  include Interactor

  attr_reader :person_id, :repository

  def initialize(person_id, repository: PersonRepository.new)
    @person_id = person_id
    @repository = repository
  end

  def call
    delete_person_moments!
    repository.delete(person_id)
  end

  private

  def delete_person_moments!
    person.moments.each do |moment|
      DestroyMoment.call(moment.id)
    end
  end

  def person
    @_person ||= repository.find_with_moments(person_id)
  end
end
