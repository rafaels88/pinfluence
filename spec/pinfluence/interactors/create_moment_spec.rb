require 'spec_helper'

describe CreateMoment do
  after { database_clean }

  describe '#call' do
    let(:year_begin) { 1000 }
    let(:year_end) { 1100 }
    let(:latlng) { '100,-100' }
    let(:address) { 'Rio de Janeiro, Brazil' }
    let(:locations_params) { [{ address: address, id: nil }] }
    let(:location_info) { double 'LocationInfo', latlng: latlng }
    let(:location_service) do
      double 'LocationService', by_address: location_info
    end
    let(:moment_repository) { MomentRepository.new }
    let(:location_repository) { LocationRepository.new }

    subject do
      described_class.new(
        influencer: influencer_params,
        locations: locations_params,
        year_begin: year_begin,
        year_end: year_end,
        location_service: location_service
      )
    end

    before { subject.call }

    context 'when associated influencer is a new person' do
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

    context 'when associated influencer is a person' do
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
