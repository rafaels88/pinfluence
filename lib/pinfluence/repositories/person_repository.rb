class PersonRepository
  include Hanami::Repository

  def self.search_by_name(name)
    query do
      where("lower(name) = '#{name.downcase}'")
    end.all
  end
end
