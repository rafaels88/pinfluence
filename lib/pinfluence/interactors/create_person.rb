require_relative './interactor'

class CreatePerson
  include Interactor

  attr_reader :name, :gender, :repository, :indexer

  def initialize(name:, gender:, opts: {})
    @name = name
    @gender = gender
    @repository = opts[:repository] || PersonRepository.new
    @indexer = opts[:indexer] || Influencers::Indexer
  end

  def call
    person = repository.create(new_person)
    add_index(person)
    person
  end

  private

  def new_person
    Person.new(name: name, gender: gender)
  end

  def add_index(person)
    indexer.new(influencers: [person]).save
  end
end
