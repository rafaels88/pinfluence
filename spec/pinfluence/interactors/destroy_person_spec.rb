require 'spec_helper'

describe DestroyPerson do
  after { database_clean }

  describe '#call' do
    let(:person) { create :person }
    let!(:moment) { create :moment, person_id: person.id }
    let(:person_repository) { PersonRepository.new }
    let(:moment_repository) { MomentRepository.new }

    let(:indexer_instance) { double :InfluencerIndexerInstance, delete: true, save: true }
    let(:indexer) { double :InfluencerIndexer, new: indexer_instance }
    let(:opts) { { indexer: indexer } }

    subject { described_class.new(person.id, opts: opts) }

    it 'destroys the person' do
      subject.call
      found_person = person_repository.find(person.id)
      expect(found_person).to be_nil
    end

    it 'destroys related moments' do
      subject.call
      found_moment = moment_repository.find(moment.id)
      expect(found_moment).to be_nil
    end

    it 'destroys index for the person' do
      expect(indexer_instance).to receive(:delete)
      subject.call
    end
  end
end
