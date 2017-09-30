require 'spec_helper'

describe UpdateMoment do
  after { database_clean }

  describe '#call' do
    let(:new_year_begin) { 500 }
    let(:new_year_end) { 600 }
    let(:latlng) { '100,-100' }
    let(:address) { 'Updated address' }
    let(:moment_params) { { year_begin: new_year_begin, year_end: new_year_end, id: moment.id } }
    let(:locations_params) { [{ address: address, id: location.id }] }
    let(:location_info) { double 'LocationInfo', latlng: latlng }
    let(:location_service) { double 'LocationService', by_address: location_info }
    let(:moment_repository) { MomentRepository.new }
    let(:location_repository) { LocationRepository.new }
    let(:influencer_indexer) { double :InfluencerIndexer }
    let(:moment) { create :moment, year_begin: 1000, year_end: 1100 }
    let(:location) { create :location, address: 'Old', moment_id: moment.id }
    let(:influencer) { create :person }
    let(:influencer_params) { { id: influencer.id, type: influencer.type } }
    let(:found_moment) { moment_repository.search_by_influencer(influencer).first }
    let(:opts) { { location_service: location_service, indexer: influencer_indexer } }

    subject do
      described_class.new(
        moment: moment_params,
        influencer: influencer_params,
        locations: locations_params,
        opts: opts
      )
    end

    before do
      allow(influencer_indexer).to receive_message_chain(:new, :save) { true }
      subject.call
    end

    context 'when associated influencer is a new person' do
      let(:influencer_params) { { name: 'New Person', type: 'person', gender: 'female' } }
      let(:new_influencer) { PersonRepository.new.last }
      let(:found_moment) { moment_repository.search_by_influencer(new_influencer).first }

      it 'creates new person' do
        expect(new_influencer).to_not be_nil
        expect(new_influencer.gender).to eq 'female'
      end

      it 'updates given moment' do
        expect(found_moment.person_id).to eq new_influencer.id
        expect(found_moment.event_id).to be_nil
        expect(found_moment.year_begin).to eq new_year_begin
        expect(found_moment.year_end).to eq new_year_end
        expect(found_moment.updated_at).to_not be_nil
        expect(found_moment.created_at).to_not be_nil
      end

      it 'updates given locations' do
        found_location = location_repository.by_moment(found_moment).first
        expect(found_location.address).to eq address
        expect(found_location.latlng).to eq latlng
      end

      it 'updates #earliest_year of the new person' do
        expect(new_influencer.earliest_year).to eq new_year_begin
      end
    end

    context 'when associated influencer is a new event' do
      let(:influencer_params) { { name: 'New Event', type: 'event' } }
      let(:new_influencer) { EventRepository.new.last }
      let(:found_moment) { moment_repository.search_by_influencer(new_influencer).first }

      it 'creates new event' do
        expect(new_influencer).to_not be_nil
      end

      it 'updates given moment' do
        expect(found_moment.event_id).to eq new_influencer.id
        expect(found_moment.person_id).to be_nil
        expect(found_moment.year_begin).to eq new_year_begin
        expect(found_moment.year_end).to eq new_year_end
        expect(found_moment.updated_at).to_not be_nil
        expect(found_moment.created_at).to_not be_nil
      end

      it 'updates given locations' do
        found_location = location_repository.by_moment(found_moment).first
        expect(found_location.address).to eq address
        expect(found_location.latlng).to eq latlng
      end

      it 'updates #earliest_year of the new event' do
        expect(new_influencer.earliest_year).to eq new_year_begin
      end
    end

    context 'when associated influencer is an existent person' do
      let(:influencer) { create :person, name: 'Existent Person' }

      it 'updates given moment' do
        expect(found_moment.person_id).to eq influencer.id
        expect(found_moment.event_id).to be_nil
        expect(found_moment.year_begin).to eq new_year_begin
        expect(found_moment.year_end).to eq new_year_end
        expect(found_moment.updated_at).to_not be_nil
        expect(found_moment.created_at).to_not be_nil
      end

      it 'updates given locations' do
        found_location = location_repository.by_moment(found_moment).first
        expect(found_location.address).to eq address
        expect(found_location.latlng).to eq latlng
      end

      it 'updates #earliest_year of the person' do
        person = PersonRepository.new.last
        expect(person.earliest_year).to eq new_year_begin
      end
    end

    context 'when associated influencer is an existent event' do
      let(:influencer) { create :event, name: 'Existent Event' }

      it 'updates given moment' do
        expect(found_moment.event_id).to eq influencer.id
        expect(found_moment.person_id).to be_nil
        expect(found_moment.year_begin).to eq new_year_begin
        expect(found_moment.year_end).to eq new_year_end
        expect(found_moment.updated_at).to_not be_nil
        expect(found_moment.created_at).to_not be_nil
      end

      it 'updates given locations' do
        found_location = location_repository.by_moment(found_moment).first
        expect(found_location.address).to eq address
        expect(found_location.latlng).to eq latlng
      end

      it 'updates #earliest_year of the event' do
        event = EventRepository.new.last
        expect(event.earliest_year).to eq new_year_begin
      end
    end

    context 'when it has new location' do
      let(:locations_params) do
        [
          { address: address, id: location.id },
          { address: 'Another one', id: nil }
        ]
      end

      it 'updates associated location' do
        found_location = location_repository.by_moment(found_moment).first
        expect(found_location.address).to eq address
        expect(found_location.latlng).to eq latlng
      end

      it 'creates new location associated to the moment' do
        found_location = location_repository.by_moment(found_moment).last
        expect(found_location.address).to eq 'Another one'
        expect(found_location.latlng).to eq latlng
      end
    end

    context 'when end year is nil' do
      let(:new_year_end) { nil }

      it 'updates given moment' do
        expect(found_moment.year_begin).to eq new_year_begin
        expect(found_moment.year_end).to be_nil
        expect(found_moment.updated_at).to_not be_nil
        expect(found_moment.created_at).to_not be_nil
      end
    end

    context 'when end year is blank' do
      let(:new_year_end) { '' }

      it 'updates given moment' do
        expect(found_moment.year_begin).to eq new_year_begin
        expect(found_moment.year_end).to be_nil
        expect(found_moment.updated_at).to_not be_nil
        expect(found_moment.created_at).to_not be_nil
      end
    end
  end
end
