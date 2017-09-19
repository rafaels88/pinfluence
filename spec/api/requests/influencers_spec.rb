require 'spec_helper'
require 'hanami_request_test'

RSpec.describe 'API influencers', type: :request, vcr: true do
  include HanamiRequestTest

  subject { last_json_response }
  let(:endpoint) { '/api' }

  context 'when searching for :name' do
    context 'when no result is found' do
      it 'returns an empty :data[:influencers] list' do
        post endpoint, query: '{ influencers(name: "Socrates") { id } }'
        expect(last_json_response[:data][:influencers]).to be_empty
      end
    end

    context 'with an incomplete name as argument' do
      context 'when some influencers are found' do
        let!(:influencer01) { create :person, id: 1, name: 'Dom Pedro I' }
        let!(:influencer02) { create :person, id: 2, name: 'Dom Pedro II' }
        let!(:moment01) { create :moment, year_begin: 1000, person_id: influencer01.id }
        let!(:moment02) { create :moment, year_begin: 1100, person_id: influencer02.id }

        before { post endpoint, query: '{ influencers(name: "Pedr") { id name gender kind earliest_year_in } }' }
        after { database_clean }

        it 'returns a list of influencers' do
          expect(last_json_response[:data][:influencers].count).to eq 2
          expect(last_json_response[:data][:influencers][0]).to eq(
            id: influencer02.id,
            name: influencer02.name,
            gender: influencer02.gender,
            kind: influencer02.type.to_s.downcase,
            earliest_year_in: moment02.year_begin
          )

          expect(last_json_response[:data][:influencers][1]).to eq(
            id: influencer01.id,
            name: influencer01.name,
            gender: influencer01.gender,
            kind: influencer01.type.to_s.downcase,
            earliest_year_in: moment01.year_begin
          )
        end
      end
    end
  end
end
