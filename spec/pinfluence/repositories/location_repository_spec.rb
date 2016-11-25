require 'spec_helper'

describe LocationRepository do
  let(:moment_repository) { MomentRepository.new }
  let(:location_repository) { LocationRepository.new }
  let(:person_repository) { PersonRepository.new }

  after do
    location_repository.clear
    moment_repository.clear
    person_repository.clear
  end

  describe "#by_moment" do
    let(:influencer) do
      person_repository.create Person.new(name: "Person", gender: "female")
    end
    let(:moment_01) do
      moment_repository.create Moment.new(year_begin: 100, influencer_id: influencer.id, influencer_type: "Person")
    end
    let(:moment_02) do
      moment_repository.create Moment.new(year_begin: 200, influencer_id: influencer.id, influencer_type: "Person")
    end
    let(:location_01) { Location.new(moment_id: moment_01.id, address: "Address 1", latlng: "0,0") }
    let(:location_02) { Location.new(moment_id: moment_01.id, address: "Address 2", latlng: "0,0") }
    let(:location_03) { Location.new(moment_id: moment_02.id, address: "Address 3", latlng: "0,0") }

    before do
      location_repository.create location_01
      location_repository.create location_02
      location_repository.create location_03
    end

    it "list all locations by given moment" do
      expected_locations = [location_01.address, location_02.address]

      result = location_repository.by_moment(moment_01)
      assert_equal expected_locations, result.map(&:address)
    end
  end
end
