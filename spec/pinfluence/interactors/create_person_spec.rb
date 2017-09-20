require 'spec_helper'

describe CreatePerson do
  after { database_clean }

  describe '#call' do
    let(:name) { 'Irmã Dulce' }
    let(:gender) { 'female' }
    let(:person_params) { { name: name, gender: gender } }
    let(:person_repository) { PersonRepository.new }
    let(:indexer_instance) { double :InfluencerIndexerInstance, save: true }
    let(:indexer) { double :InfluencerIndexer, new: indexer_instance }

    subject { described_class.new(**person_params, opts: { indexer: indexer }) }

    it 'creates new person' do
      subject.call
      found_person = person_repository.last
      expect(found_person.name).to eq name
      expect(found_person.gender).to eq gender
      expect(found_person.updated_at).to_not be_nil
      expect(found_person.created_at).to_not be_nil
    end

    it 'indexes the created person' do
      expect(indexer_instance).to receive(:save)
      subject.call
    end
  end
end
