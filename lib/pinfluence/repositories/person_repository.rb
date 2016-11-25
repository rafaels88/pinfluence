class PersonRepository < Hanami::Repository

  def search_by_name(name)
    query do
      where("lower(name) = '#{name.downcase}'")
    end.all
  end

  def all_ordered_by(field)
    query do
      order(field)
    end.all
  end
end
