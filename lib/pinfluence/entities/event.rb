require_relative './influencer'

class Event < Hanami::Entity
  include Influencer

  def event?
    true
  end
end
