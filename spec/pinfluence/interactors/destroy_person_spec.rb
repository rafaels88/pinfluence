require 'spec_helper'

describe DestroyPerson do
  describe "#call" do
    let(:person) { create :person }
    let!(:moment) { create :moment, person_id: person.id }
    let(:person_repository) { PersonRepository.new }
    let(:moment_repository) { MomentRepository.new }

    subject { described_class.new(person.id) }
    before { subject.call }

    it "destroys the person" do
      found_person = person_repository.find(person.id)
      expect(found_person).to be_nil
    end

    it "destroys related moments" do
      found_moment = moment_repository.find(moment.id)
      expect(found_moment).to be_nil
    end
  end
end
