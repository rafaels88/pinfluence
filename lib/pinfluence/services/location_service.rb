require 'json'
require 'uri'

class LocationService
  Location = Struct.new(:address, :latlng, :valid?)
  attr_reader :api_client

  def initialize(api_client: HTTParty)
    @api_client = api_client
  end

  def by_address(address)
    result = api_client.get(api_url(address))
    parsed = parse_result(result.body)
    build_location(parsed.first, address)
  end

  private

  def build_location(location_data, address)
    if !location_data.nil?
      latlng = "#{location_data['lat']},#{location_data['lon']}"
      Location.new(address, latlng, true)
    else
      Location.new(address, nil, false)
    end
  end

  def parse_result(raw)
    JSON.parse(raw)
  end

  def api_url(address)
    URI.escape("http://nominatim.openstreetmap.org" \
               "/search/#{address}?format=json")
  end
end
