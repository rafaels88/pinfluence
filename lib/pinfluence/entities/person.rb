require_relative './influencer'

class Person < Hanami::Entity
  include Influencer
end
