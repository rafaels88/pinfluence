class DestroyPerson
  def self.call(params)
    self.new(params).call
  end

  attr_reader :person_id, :repository

  def initialize(person_id, repository: PersonRepository)
    @person_id = person_id
    @repository = repository
  end

  def call
    delete_person_moments!
    repository.delete(person)
  end

  private

  def delete_person_moments!
    person.moments.each do |moment|
      DestroyMoment.call(moment.id)
    end
  end

  def person
    @_person ||= repository.find(person_id)
  end
end
