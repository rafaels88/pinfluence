class Moment < Hanami::Entity
  def influencer
    return person if person_id
    event
  end
end
