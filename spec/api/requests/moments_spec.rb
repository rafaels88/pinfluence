require 'spec_helper'
require 'hanami_request_test'

RSpec.describe 'API moments', type: :request do
  include HanamiRequestTest
  after { database_clean }

  subject { last_json_response }

  let(:endpoint) { '/api' }
  let(:query_fields) do
    '{ id date_begin influencer { ' \
      'id name gender type earliest_date } ' \
      'locations { id density latlng } }'
  end
  let!(:person) { create :person }
  let!(:moment) do
    create :moment, date_begin: Date.new(-200, 1, 6),
                    date_end: Date.new(-100, 11, 30), person_id: person.id
  end
  let!(:location) { create :location, address: 'Any place on earth', moment_id: moment.id }

  context 'when :date param is given' do
    context 'when no result is found' do
      it 'returns an empty :data list' do
        post endpoint, query: '{ moments(date: "100-12-01 BC") { id } }'
        expect(last_json_response[:data][:moments]).to be_empty
      end
    end

    context 'when some moments are found' do
      before { post endpoint, query: "{ moments(date: \"190-10-23 BC\") #{query_fields} }" }

      it 'returns a list of moments of the given date' do
        expect(last_json_response[:data][:moments].count).to eq 1
        expect(last_json_response[:data][:moments][0]).to eq(
          id: moment.id,
          date_begin: '-0200-01-06',
          locations: [{ id: location.id, density: location.density, latlng: location.latlng.split(',') }],
          influencer: { id: person.id, name: person.name, earliest_date: nil,
                        gender: person.gender, type: person.type.to_s.downcase }
        )
      end

      context 'when :limit param is given' do
        let(:limit) { 1 }
        before { post endpoint, query: "{ moments(date: \"110-10-23 BC\", limit: #{limit}) #{query_fields} }" }

        it 'returns a limited number of resources' do
          expect(last_json_response[:data][:moments].count).to eq limit
        end
      end
    end
  end
end
