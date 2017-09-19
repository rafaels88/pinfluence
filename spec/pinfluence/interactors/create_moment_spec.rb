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

    before { allow(influencer_indexer).to receive_message_chain(:new, :save) { true } }

    subject do
      described_class.new(
        influencer: influencer_params,
        locations: locations_params,
        moment: moment_params,
        opts: { location_service: location_service, influencer_indexer: influencer_indexer }
      )
    end

    context 'when latlng is not found by given address' do
      let(:latlng) { nil }
      let(:influencer) { create :person }
      let(:influencer_params) { { id: influencer.id, type: influencer.type } }

      it 'returns #failure? == true' do
        result = subject.call
        expect(result.failure?).to eq true
      end

      it 'returns an error description' do
        result = subject.call
        expect(result.errors).to_not be_empty
      end

      it 'does not create a new moment' do
        subject.call
        found_moment = moment_repository.search_by_influencer(influencer)
                                        .first
        expect(found_moment).to be_nil
      end
    end

    context 'when associated influencer is a new person' do
      before { subject.call }

      let(:influencer_params) do
        { name: 'New Person', type: 'person', gender: 'female' }
      end
      let(:influencer) do
        PersonRepository.new.search_by_name('New Person')[0]
      end

      it 'creates new person' do
        expect(influencer).to_not be_nil
        expect(influencer.gender).to eq 'female'
      end

      it 'creates new moment' do
        found_moment = moment_repository.search_by_influencer(influencer)
                                        .first

        expect(found_moment.person_id).to eq influencer.id
        expect(found_moment.year_begin).to eq year_begin
        expect(found_moment.year_end).to eq year_end
        expect(found_moment.updated_at).to_not be_nil
        expect(found_moment.created_at).to_not be_nil
      end

      it 'creates new locations associated to the new moment' do
        found_moment = moment_repository.search_by_influencer(influencer)
                                        .first
        found_location = location_repository.by_moment(found_moment).first
        expect(found_location.latlng).to eq latlng
        expect(found_location.address).to eq address
      end
    end

    context 'when associated influencer is an existent person' do
      before { subject.call }

      let(:influencer) { create :person }
      let(:influencer_params) { { id: influencer.id, type: influencer.type } }

      it 'creates new moment' do
        found_moment = moment_repository.search_by_influencer(influencer)
                                        .first

        expect(found_moment.person_id).to eq influencer.id
        expect(found_moment.year_begin).to eq year_begin
        expect(found_moment.year_end).to eq year_end
        expect(found_moment.updated_at).to_not be_nil
        expect(found_moment.created_at).to_not be_nil
      end

      it 'creates new locations associated to the new moment' do
        found_moment = moment_repository.search_by_influencer(influencer)
                                        .first
        found_location = location_repository.by_moment(found_moment).first
        expect(found_location.latlng).to eq latlng
        expect(found_location.address).to eq address
      end

      context 'when end_year is nil' do
        let(:year_end) { nil }

        it 'creates new moment' do
          found_moment = moment_repository.search_by_influencer(influencer)
                                          .first

          expect(found_moment.person_id).to eq influencer.id
          expect(found_moment.year_begin).to eq year_begin
          expect(found_moment.year_end).to be_nil
          expect(found_moment.updated_at).to_not be_nil
          expect(found_moment.created_at).to_not be_nil
        end
      end

      context 'when end_year is blank' do
        let(:year_end) { '' }

        it 'creates new moment' do
          found_moment = moment_repository.search_by_influencer(influencer)
                                          .first

          expect(found_moment.person_id).to eq influencer.id
          expect(found_moment.year_begin).to eq year_begin
          expect(found_moment.year_end).to be_nil
          expect(found_moment.updated_at).to_not be_nil
          expect(found_moment.created_at).to_not be_nil
        end
      end
    end
  end
end
