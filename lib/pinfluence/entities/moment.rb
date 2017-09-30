class Moment < Hanami::Entity
  def influencer
    return person if person_id
    event
  end

  def influencer_id
    return person_id if person_id
    event_id
  end

  def influencer_type
    if person_id
      :person
    elsif event_id
      :event
    end
  end
end
