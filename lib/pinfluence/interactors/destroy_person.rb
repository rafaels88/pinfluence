require_relative './interactor'

class DestroyPerson
  include Interactor

  attr_reader :person_id, :person_repository, :indexer_class, :opts

  def initialize(person_id, opts: {})
    @person_id = person_id
    @opts = opts
    @person_repository = opts[:person_repository] || PersonRepository.new
    @indexer_class = opts[:indexer] || Influencers::Indexer
  end

  def call
    delete_person_moments!
    delete_index!
    person_repository.delete(person_id)
  end

  private

  def delete_person_moments!
    person.moments.each do |moment|
      DestroyMoment.call(moment.id, opts: opts)
    end
  end

  def delete_index!
    indexer_class.new(influencers: [person], index_object: Influencers::PersonIndexObject).delete
  end

  def person
    @_person ||= person_repository.find_with_moments(person_id)
  end
end
