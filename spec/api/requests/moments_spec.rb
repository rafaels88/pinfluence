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
    create :moment, date_begin: Date.new(100, 1, 6), date_end: Date.new(200, 11, 30), person_id: person.id
  end
  let!(:location) { create :location, address: 'Any place on earth', moment_id: moment.id }

  context 'when :date param is given' do
    context 'when no result is found' do
      it 'returns an empty :data list' do
        post endpoint, query: '{ moments(date: "200-12-01") { id } }'
        expect(last_json_response[:data][:moments]).to be_empty
      end
    end

    context 'when some moments are found' do
      before { post endpoint, query: "{ moments(date: \"110-10-23\") #{query_fields} }" }

      it 'returns a list of moments of the given date' do
        expect(last_json_response[:data][:moments].count).to eq 1
        expect(last_json_response[:data][:moments][0]).to eq(
          id: moment.id,
          date_begin: moment.date_begin.to_s,
          locations: [{ id: location.id, density: location.density, latlng: location.latlng.split(',') }],
          influencer: { id: person.id, name: person.name, earliest_date: nil,
                        gender: person.gender, type: person.type.to_s.downcase }
        )
      end

      context 'when :limit param is given' do
        let(:limit) { 1 }
        before { post endpoint, query: "{ moments(date: \"110-10-23\", limit: #{limit}) #{query_fields} }" }

        it 'returns a limited number of resources' do
          expect(last_json_response[:data][:moments].count).to eq limit
        end
      end
    end
  end
end
