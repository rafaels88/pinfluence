require_relative './influencer'

class Event < Hanami::Entity
  include Influencer
end
