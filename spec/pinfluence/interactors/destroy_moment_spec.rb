require 'spec_helper'

describe DestroyMoment do
  describe "#call" do
    let(:moment) { create :moment }
    let(:moment_repository) { MomentRepository.new }

    subject { described_class.new(moment.id) }
    before { subject.call }

    it "destroys given moment" do
      found_moment = moment_repository.find(moment.id)
      expect(found_moment).to be_nil
    end
  end
end
