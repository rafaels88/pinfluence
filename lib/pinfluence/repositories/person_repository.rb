class PersonRepository < Hanami::Repository
  associations do
    has_many :moments
  end

  def find_with_moments(id)
    aggregate(:moments)
      .where(people__id: id)
      .map_to(Person)
      .one
  end

  def search_by_name(name)
    people
      .where("lower(name) = '#{name.downcase}'")
      .map_to(Person)
      .call.collection
  end

  def all_ordered_by(field)
    people
      .order(field)
      .map_to(Person)
      .call.collection
  end
end
