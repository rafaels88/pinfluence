require 'spec_helper'

describe DestroyEvent do
  after { database_clean }

  describe '#call' do
    let(:event) { create :event }
    let!(:moment) { create :moment, event_id: event.id }
    let(:event_repository) { EventRepository.new }
    let(:moment_repository) { MomentRepository.new }
    let(:indexer_instance) { double :InfluencerIndexerInstance, delete: true, save: true }
    let(:indexer) { double :InfluencerIndexer, new: indexer_instance }
    let(:opts) { { indexer: indexer } }

    subject { described_class.new(event.id, opts: opts) }

    it 'destroys the event' do
      subject.call

      found_event = event_repository.find(event.id)
      expect(found_event).to be_nil
    end

    it 'destroys related moments' do
      subject.call

      found_moment = moment_repository.find(moment.id)
      expect(found_moment).to be_nil
    end

    it 'destroys index for the event' do
      expect(indexer_instance).to receive(:delete)
      subject.call
    end
  end
end
