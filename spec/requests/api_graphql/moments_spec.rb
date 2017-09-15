require 'spec_helper'
require 'hanami_request_test'

RSpec.describe 'GRAPHQL API moments', :type => :request do
  include HanamiRequestTest

  subject { last_json_response }
  let(:endpoint) { '/api_graphql' }

  context 'when :name param is given' do
    context 'when no result is found' do
      it 'returns an empty :data list' do
        post endpoint, query: '{ moments(influencer_name: "Socrates") { id } }'
        expect(last_json_response[:data][:moments]).to be_empty
      end
    end

    context 'when some moments are found' do
      let!(:influencer) { create :person, name: "Socrates" }
      let!(:moment1) { create :moment, year_begin: -200, year_end: -100, person_id: influencer.id }
      let!(:moment2) { create :moment, year_begin: -99, year_end: -80, person_id: influencer.id }
      let!(:location1) { create :location, address: 'Any place on earth', moment_id: moment1.id }
      let!(:location2) { create :location, address: 'Any place on earth', moment_id: moment2.id }

      before { post endpoint, query: '{ moments(influencer_name: "Socrates") { id influencer { id name gender kind } locations { id density latlng } year_begin } }' }
      after { database_clean }

      it "returns a list of moments of the given influencer's name" do
        expect(last_json_response[:data][:moments].count).to eq 2
        expect(last_json_response[:data][:moments][0]).to eq(
          id: moment1.id,
          year_begin: moment1.year_begin,
          locations: [{ id: location1.id, density: location1.density, latlng: location1.latlng.split(',') }],
          influencer: { id: influencer.id, name: influencer.name,
                        gender: influencer.gender, kind: influencer.type.to_s.downcase }
        )

        expect(last_json_response[:data][:moments][1]).to eq(
          id: moment2.id,
          year_begin: moment2.year_begin,
          locations: [{ id: location2.id, density: location2.density, latlng: location2.latlng.split(',') }],
          influencer: { id: influencer.id, name: influencer.name,
                        gender: influencer.gender, kind: influencer.type.to_s.downcase }
        )
      end
    end
  end

  context 'when :year param is given' do
    context 'when no result is found' do
      it 'returns an empty :data list' do
        post endpoint, query: '{ moments(year: 1000) { id } }'
        expect(last_json_response[:data][:moments]).to be_empty
      end
    end

    context 'when some moments are found' do
      let!(:influencer) { create :person }
      let!(:moment) { create :moment, year_begin: -200, year_end: -100, person_id: influencer.id }
      let!(:location) { create :location, address: 'Any place on earth', moment_id: moment.id }

      before { post endpoint, query: '{ moments(year: -110) { id influencer { id name gender kind } locations { id density latlng } year_begin } }' }
      after { database_clean }

      it "returns a list of moments of the given year" do
        expect(last_json_response[:data][:moments].count).to eq 1
        expect(last_json_response[:data][:moments][0]).to eq(
          id: moment.id,
          year_begin: moment.year_begin,
          locations: [{ id: location.id, density: location.density, latlng: location.latlng.split(',') }],
          influencer: { id: influencer.id, name: influencer.name,
                        gender: influencer.gender, kind: influencer.type.to_s.downcase }
        )
      end
    end
  end
end
