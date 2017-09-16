module HanamiRequestTest
  include Rack::Test::Methods

  def app
    Hanami.app
  end
end
