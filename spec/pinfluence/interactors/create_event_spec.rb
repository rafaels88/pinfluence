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
    let(:location_info) { double :LocationInfo, latlng: '100,-100' }
    let(:location_service) { double :LocationService, by_address: location_info }
    let(:opts) { { indexer: indexer, location_service: location_service } }

    subject do
      described_class.new(event: event_params, moments: moments_params, opts: opts)
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

      context 'with a list of locations' do
        let(:moments_params) do
          [
            { id: '', year_begin: '200', year_end: '300', locations: [location01, location02] }
          ]
        end

        context 'with empty ids' do
          let(:location01) { { id: '', address: 'A place on earth' } }
          let(:location02) { { id: '', address: 'Another place on earth' } }

          it 'creates all the new locations associated to the related moment' do
            found_event = event_repository.last
            created_moment = MomentRepository.new.search_by_influencer(found_event).first

            locations = LocationRepository.new.by_moment(created_moment)
            expect(locations.count).to eq 2
            expect(locations.first.address).to eq location01[:address]
            expect(locations.last.address).to eq location02[:address]
          end
        end
      end
    end
  end
end
