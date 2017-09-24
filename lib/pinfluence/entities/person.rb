require_relative './influencer'

class Person < Hanami::Entity
  include Influencer

  def person?
    true
  end
end
