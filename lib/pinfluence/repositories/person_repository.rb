class PersonRepository < Hanami::Repository
  def search_by_name(name)
    people
      .where("lower(name) = '#{name.downcase}'")
      .call
      .collection
  end

  def all_ordered_by(field)
    query do
      order(field)
    end.all
  end
end
