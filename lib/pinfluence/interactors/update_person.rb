require_relative './interactor'

class UpdatePerson
  include Interactor

  attr_reader :id, :name, :gender, :repository, :indexer

  def initialize(id:, name:, gender:, opts: {})
    @id = id
    @name = name
    @gender = gender
    @repository = opts[:repository] || PersonRepository.new
    @indexer = opts[:indexer] || Influencers::Indexer
  end

  def call
    person = repository.update(id, **changed_person)
    update_index(person)
    person
  end

  private

  def changed_person
    { name: name, gender: gender }
  end

  def update_index(person)
    indexer.new(influencers: [person]).save
  end
end
