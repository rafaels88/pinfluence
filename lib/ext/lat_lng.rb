require 'hanami/model/coercer'

class LatLng < Hanami::Model::Coercer
  def self.dump(value)
    #self.normalize_format(value)
    value
  end

  def self.load(value)
    self.normalize_format(value)
  end

  private

  def self.normalize_format(value)
    if value.respond_to?(:split)
      lat, lng = value.split(",")
      value = [lat, lng]
    end
    value
  end
end
