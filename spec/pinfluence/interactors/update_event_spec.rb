require 'spec_helper'

describe UpdateEvent do
  after { database_clean }

  describe '#call' do
    let(:event) { create :event, name: 'Old name' }

    let(:new_name) { 'World War' }
    let(:new_earliest_year) { 1000 }
    let(:update_params) { { name: new_name, earliest_year: new_earliest_year } }
    let(:event_params) { update_params.merge(id: event.id) }
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

    it 'updates given event' do
      subject.call

      found_event = event_repository.last
      expect(found_event.name).to eq new_name
      expect(found_event.earliest_year).to eq new_earliest_year
      expect(found_event.updated_at).to_not be_nil
      expect(found_event.created_at).to_not be_nil
    end

    it 'reindexes the created event' do
      expect(indexer_instance).to receive(:save)
      subject.call
    end

    context 'when only one event attribute is given' do
      let(:update_params) { { earliest_year: new_earliest_year } }

      it 'updates only the given attribute' do
        subject.call

        found_event = event_repository.last
        expect(found_event.name).to eq event.name
        expect(found_event.earliest_year).to eq new_earliest_year
        expect(found_event.updated_at).to_not be_nil
        expect(found_event.created_at).to_not be_nil
      end
    end

    context 'when a list of moments is given' do
      before { subject.call }

      context 'with an empty id' do
        let(:moments_params) { [{ id: '', year_begin: '200', year_end: '300' }] }

        it 'add the new moments' do
          created_moment = MomentRepository.new.search_by_influencer(event).first

          expect(created_moment.event_id).to eq event.id
          expect(created_moment.year_begin).to eq 200
          expect(created_moment.year_end).to eq 300
        end
      end

      context 'with an empty year_begin' do
        let(:moments_params) { [{ id: '', year_begin: '', year_end: '' }] }

        it 'does not create any moment' do
          found_moments = MomentRepository.new.search_by_influencer(event)

          expect(found_moments.count).to eq 0
        end
      end

      context 'with a filled id' do
        let(:existent_moment) { create(:moment, event_id: event.id, year_begin: 200, year_end: 300) }
        let(:moments_params) { [{ id: existent_moment.id, year_begin: '1000', year_end: '' }] }

        it 'updates the existent moment' do
          found_moments = MomentRepository.new.search_by_influencer(event)
          updated_moment = found_moments.first

          expect(found_moments.count).to eq 1
          expect(updated_moment.event_id).to eq event.id
          expect(updated_moment.year_begin).to eq 1000
          expect(updated_moment.year_end).to eq nil
        end

        context 'with a list of existent locations' do
          let(:existent_moment) { create(:moment, event_id: event.id, year_begin: 200, year_end: 300) }
          let!(:location01) do
            create(:location, address: 'A place on earth', latlng: '100,-100', moment_id: existent_moment.id)
          end
          let!(:location02) do
            create(:location, address: 'Another place on earth 02', latlng: '100,-100', moment_id: existent_moment.id)
          end
          let(:new_location01) { { id: location01.id, address: 'A place on earth 02' } }
          let(:new_location02) { { id: location02.id, address: 'Another place on earth 02' } }
          let(:moments_params) do
            [{ id: existent_moment.id, year_begin: '1000', year_end: '', locations: [new_location01, new_location02] }]
          end

          it 'updates all the given locations associated to the related moment' do
            found_event = event_repository.last
            created_moment = MomentRepository.new.search_by_influencer(found_event).first

            locations = LocationRepository.new.by_moment(created_moment)
            expect(locations.count).to eq 2
            expect(locations.first.address).to eq new_location01[:address]
            expect(locations.last.address).to eq new_location02[:address]
          end
        end

        context 'with a list of new locations' do
          let(:location01) { { id: nil, address: 'A place on earth' } }
          let(:location02) { { id: nil, address: 'Another place on earth' } }
          let(:moments_params) do
            [{ id: '', year_begin: '200', year_end: '300', locations: [location01, location02] }]
          end

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
