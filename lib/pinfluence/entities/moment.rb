class Moment < Hanami::Entity
  def influencer
    Person.new(person) if person_id
  end
end
