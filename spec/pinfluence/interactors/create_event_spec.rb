require 'spec_helper'

describe CreateEvent do
  after { database_clean }

  describe '#call' do
    let(:name) { 'Second World War' }
    let(:event_params) { { name: name } }
    let(:moments_params) { [] }
    let(:event_repository) { EventRepository.new }
    let(:indexer_instance) { double :InfluencerIndexerInstance, save: true }
    let(:indexer) { double :InfluencerIndexer, new: indexer_instance }

    subject do
      described_class.new(event: event_params, moments: moments_params, opts: { indexer: indexer })
    end

    it 'creates new event' do
      subject.call
      found_event = event_repository.last
      expect(found_event.name).to eq name
      expect(found_event.type).to eq :event
      expect(found_event.updated_at).to_not be_nil
      expect(found_event.created_at).to_not be_nil
    end

    it 'indexes the created event' do
      expect(indexer_instance).to receive(:save)
      subject.call
    end

    context 'when a list of moments is given' do
      before { subject.call }

      context 'with an empty id' do
        let(:moments_params) { [{ id: '', year_begin: '200', year_end: '300' }] }

        it 'add the new moments' do
          found_event = event_repository.last
          created_moment = MomentRepository.new.search_by_influencer(found_event).first

          expect(created_moment.event_id).to eq found_event.id
          expect(created_moment.year_begin).to eq 200
          expect(created_moment.year_end).to eq 300
        end

        it 'sets #earliest_year as the current earlier year associated' do
          subject.call
          found_event = event_repository.last
          expect(found_event.earliest_year).to eq 200
        end
      end

      context 'with an empty year_begin' do
        let(:moments_params) { [{ id: '', year_begin: '', year_end: '' }] }

        it 'does not create any moment' do
          found_event = event_repository.last
          found_moments = MomentRepository.new.search_by_influencer(found_event)

          expect(found_moments.count).to eq 0
        end
      end
    end
  end
end
