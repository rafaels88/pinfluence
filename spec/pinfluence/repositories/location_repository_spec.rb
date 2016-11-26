require 'spec_helper'

describe LocationRepository do
  subject { LocationRepository.new }

  after { database_clean }

  describe "#by_moment" do
    let(:influencer) { create :person }
    let(:moment_01) { create :moment, influencer_id: influencer.id, influencer_type: "Person" }
    let(:moment_02) { create :moment, influencer_id: influencer.id, influencer_type: "Person" }
    let(:location_01) { build :location, moment_id: moment_01.id, address: "Address 1" }
    let(:location_02) { build :location, moment_id: moment_01.id, address: "Address 2" }
    let(:location_03) { build :location, moment_id: moment_02.id, address: "Address 3" }

    before do
      subject.create location_01
      subject.create location_02
      subject.create location_03
    end

    it "list all locations by given moment" do
      expected_locations = [location_01.address, location_02.address]

      result = subject.by_moment(moment_01)
      assert_equal expected_locations, result.map(&:address)
    end
  end
end
