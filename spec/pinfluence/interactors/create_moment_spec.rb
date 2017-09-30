require 'spec_helper'

describe CreateMoment do
  after { database_clean }

  describe '#call' do
    let(:year_begin) { 1000 }
    let(:year_end) { 1100 }
    let(:latlng) { '100,-100' }
    let(:address) { 'Rio de Janeiro, Brazil' }
    let(:moment_params) { { year_begin: year_begin, year_end: year_end } }
    let(:locations_params) { [{ address: address, id: nil }] }
    let(:location_info) { double 'LocationInfo', latlng: latlng }
    let(:location_service) { double 'LocationService', by_address: location_info }
    let(:moment_repository) { MomentRepository.new }
    let(:location_repository) { LocationRepository.new }
    let(:influencer_indexer) { double :InfluencerIndexer }
    let(:opts) { { location_service: location_service, indexer: influencer_indexer } }

    before do
      allow(influencer_indexer).to receive_message_chain(:new, :save) { true }
    end

    subject do
      described_class.new(
        influencer: influencer_params,
        locations: locations_params,
        moment: moment_params,
        opts: opts
      )
    end

    context 'when latlng is not found by given address' do
      let(:latlng) { nil }
      let(:influencer) { create :person }
      let(:influencer_params) { { id: influencer.id, type: influencer.type } }

      it 'does not create a new moment' do
        subject.call
        created_moment = moment_repository.search_by_influencer(influencer).first
        expect(created_moment).to be_nil
      end
    end

    context 'when associated influencer is a new person' do
      let(:influencer_params) { { name: 'New Person', type: 'person', gender: 'female' } }
      let(:influencer) { PersonRepository.new.search_by_name('New Person')[0] }
      let(:created_moment) { moment_repository.search_by_influencer(influencer).first }

      before { subject.call }

      it 'creates a new person' do
        expect(influencer).to_not be_nil
        expect(influencer.gender).to eq 'female'
      end

      it 'creates a new moment' do
        expect(created_moment.person_id).to eq influencer.id
        expect(created_moment.year_begin).to eq year_begin
        expect(created_moment.year_end).to eq year_end
        expect(created_moment.updated_at).to_not be_nil
        expect(created_moment.created_at).to_not be_nil
      end

      it 'creates new locations associated to the new moment' do
        found_location = location_repository.by_moment(created_moment).first
        expect(found_location.latlng).to eq latlng
        expect(found_location.address).to eq address
      end

      it 'updates #earliest_year of the new person' do
        expect(influencer.earliest_year).to eq year_begin
      end
    end

    context 'when associated influencer is a new event' do
      let(:influencer_params) { { name: 'New Event', type: 'event' } }
      let(:influencer) { EventRepository.new.last }
      let(:created_moment) { moment_repository.search_by_influencer(influencer).first }

      before { subject.call }

      it 'creates new event' do
        expect(influencer).to_not be_nil
        expect(influencer.name).to eq 'New Event'
      end

      it 'creates new moment' do
        expect(created_moment.event_id).to eq influencer.id
        expect(created_moment.year_begin).to eq year_begin
        expect(created_moment.year_end).to eq year_end
        expect(created_moment.updated_at).to_not be_nil
        expect(created_moment.created_at).to_not be_nil
      end

      it 'creates new locations associated to the new moment' do
        found_location = location_repository.by_moment(created_moment).first
        expect(found_location.latlng).to eq latlng
        expect(found_location.address).to eq address
      end

      it 'updates #earliest_year of the new event' do
        expect(influencer.earliest_year).to eq year_begin
      end
    end

    context 'when associated influencer is an existent person' do
      let(:influencer) { create :person }
      let(:influencer_params) { { id: influencer.id, type: influencer.type } }
      let(:created_moment) { moment_repository.search_by_influencer(influencer).first }

      before { subject.call }

      it 'creates new moment' do
        expect(created_moment.person_id).to eq influencer.id
        expect(created_moment.year_begin).to eq year_begin
        expect(created_moment.year_end).to eq year_end
        expect(created_moment.updated_at).to_not be_nil
        expect(created_moment.created_at).to_not be_nil
      end

      it 'creates new locations associated to the new moment' do
        found_location = location_repository.by_moment(created_moment).first

        expect(found_location.latlng).to eq latlng
        expect(found_location.address).to eq address
      end

      it 'does not create a new person' do
        existent_person = PersonRepository.new.last
        expect(existent_person.id).to eq influencer.id
      end

      it 'updates #earliest_year of the existent person' do
        existent_person = PersonRepository.new.last
        expect(existent_person.earliest_year).to eq year_begin
      end

      context 'when end_year is nil' do
        let(:year_end) { nil }

        it 'creates new moment' do
          created_moment = moment_repository.search_by_influencer(influencer).first

          expect(created_moment.person_id).to eq influencer.id
          expect(created_moment.year_begin).to eq year_begin
          expect(created_moment.year_end).to be_nil
          expect(created_moment.updated_at).to_not be_nil
          expect(created_moment.created_at).to_not be_nil
        end
      end

      context 'when end_year is blank' do
        let(:year_end) { '' }

        it 'creates new moment' do
          created_moment = moment_repository.search_by_influencer(influencer).first

          expect(created_moment.person_id).to eq influencer.id
          expect(created_moment.year_begin).to eq year_begin
          expect(created_moment.year_end).to be_nil
          expect(created_moment.updated_at).to_not be_nil
          expect(created_moment.created_at).to_not be_nil
        end
      end
    end

    context 'when associated influencer is an existent event' do
      let(:influencer) { create :event }
      let(:influencer_params) { { id: influencer.id, type: influencer.type } }
      let(:created_moment) { moment_repository.search_by_influencer(influencer).first }

      before { subject.call }

      it 'creates new moment' do
        expect(created_moment.event_id).to eq influencer.id
        expect(created_moment.year_begin).to eq year_begin
        expect(created_moment.year_end).to eq year_end
        expect(created_moment.updated_at).to_not be_nil
        expect(created_moment.created_at).to_not be_nil
      end

      it 'creates new locations associated to the new moment' do
        found_location = location_repository.by_moment(created_moment).first
        expect(found_location.latlng).to eq latlng
        expect(found_location.address).to eq address
      end

      it 'does not create a new event' do
        existent_event = EventRepository.new.last
        expect(existent_event.id).to eq influencer.id
      end

      it 'updates #earliest_year of the existent event' do
        existent_person = EventRepository.new.last
        expect(existent_person.earliest_year).to eq year_begin
      end

      context 'when end_year is nil' do
        let(:year_end) { nil }

        it 'creates new moment' do
          created_moment = moment_repository.search_by_influencer(influencer).first

          expect(created_moment.event_id).to eq influencer.id
          expect(created_moment.year_begin).to eq year_begin
          expect(created_moment.year_end).to be_nil
          expect(created_moment.updated_at).to_not be_nil
          expect(created_moment.created_at).to_not be_nil
        end
      end

      context 'when end_year is blank' do
        let(:year_end) { '' }

        it 'creates new moment' do
          created_moment = moment_repository.search_by_influencer(influencer).first

          expect(created_moment.event_id).to eq influencer.id
          expect(created_moment.year_begin).to eq year_begin
          expect(created_moment.year_end).to be_nil
          expect(created_moment.updated_at).to_not be_nil
          expect(created_moment.created_at).to_not be_nil
        end
      end
    end
  end
end
