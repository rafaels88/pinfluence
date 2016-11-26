class PersonRepository < Hanami::Repository
  def search_by_name(name)
    people
      .where("lower(name) = '#{name.downcase}'")
      .call
      .collection
  end

  def all_ordered_by(field)
    people
      .order(field)
      .call
      .collection
  end
end
