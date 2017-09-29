require 'spec_helper'
require 'hanami_request_test'

RSpec.describe 'API moments', type: :request do
  include HanamiRequestTest

  subject { last_json_response }
  let(:endpoint) { '/api' }
  let(:query_fields) do
    '{ id year_begin influencer { ' \
      'id name gender type earliest_year } ' \
      'locations { id density latlng } }'
  end

  context 'when :year param is given' do
    context 'when no result is found' do
      it 'returns an empty :data list' do
        post endpoint, query: '{ moments(year: 1000) { id } }'
        expect(last_json_response[:data][:moments]).to be_empty
      end
    end

    context 'when some moments are found' do
      let!(:person) { create :person }
      let!(:moment) { create :moment, year_begin: -200, year_end: -100, person_id: person.id }
      let!(:location) { create :location, address: 'Any place on earth', moment_id: moment.id }

      before { post endpoint, query: "{ moments(year: -110) #{query_fields} }" }
      after { database_clean }

      it 'returns a list of moments of the given year' do
        expect(last_json_response[:data][:moments].count).to eq 1
        expect(last_json_response[:data][:moments][0]).to eq(
          id: moment.id,
          year_begin: moment.year_begin,
          locations: [{ id: location.id, density: location.density, latlng: location.latlng.split(',') }],
          influencer: { id: person.id, name: person.name, earliest_year: nil,
                        gender: person.gender, type: person.type.to_s.downcase }
        )
      end

      context 'when :limit param is given' do
        let(:limit) { 1 }
        before { post endpoint, query: "{ moments(year: -110, limit: #{limit}) #{query_fields} }" }

        it 'returns a limited number of resources' do
          expect(last_json_response[:data][:moments].count).to eq limit
        end
      end
    end
  end
end
