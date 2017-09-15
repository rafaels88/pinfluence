require 'spec_helper'
require 'hanami_request_test'

RSpec.describe 'API moments years', :type => :request do
  include HanamiRequestTest

  subject { last_json_response }
  let(:endpoint) { '/api/moments' }

  context 'when no params are given' do
    it 'returns HTTP 400' do
      get endpoint
      expect(last_response.status).to eq 400
    end
  end

  context 'when :name param is given' do
    it 'returns HTTP 200' do
      get endpoint, name: "Socrates"
      expect(last_response.status).to eq 200
    end

    context 'when no result is found' do
      it 'returns an empty :data list' do
        get endpoint, name: "Socrates"
        expect(last_json_response[:data]).to be_empty
      end
    end

    context 'when some moments are found' do
      let(:influencer) { create :person }
      let!(:moment) { create :moment, year_begin: -200, year_end: -100, person_id: influencer.id }
      let!(:location) { create :location, address: 'Any place on earth', moment_id: moment.id }
      let(:required_year) { moment.year_begin + 10 }

      before { get endpoint, year: required_year }
      after { database_clean }

      it "returns a list of moments of the given influencer's name" do
        expect(last_json_response[:data][0]).to eq(
          id: moment.id,
          begin_in: moment.year_begin,
          locations: [{ id: location.id, density: location.density, latlng: location.latlng.split(',') }],
          influencer: { id: influencer.id, name: influencer.name,
                        gender: influencer.gender, kind: influencer.type.to_s.downcase }
        )
      end
    end
  end

  context 'when :year param is given' do
    it 'returns HTTP 200' do
      get endpoint, year: -340
      expect(last_response.status).to eq 200
    end

    context 'when no result is found' do
      it 'returns an empty :data list' do
        get endpoint, year: 1000
        expect(last_json_response[:data]).to be_empty
      end
    end

    context 'when some moments are found' do
      let(:influencer) { create :person }
      let!(:moment1) { create :moment, year_begin: -200, year_end: -100, person_id: influencer.id }
      let!(:moment2) { create :moment, year_begin: -99, year_end: -80, person_id: influencer.id }
      let!(:location1) { create :location, address: 'Any place on earth', moment_id: moment1.id }
      let!(:location2) { create :location, address: 'Any place on earth', moment_id: moment2.id }

      before { get endpoint, name: influencer.name }
      after { database_clean }

      it "returns a list of moments of the given influencer's name" do
        expect(last_json_response[:data][0]).to eq(
          id: moment1.id,
          begin_in: moment1.year_begin,
          locations: [{ id: location1.id, density: location1.density, latlng: location1.latlng.split(',') }],
          influencer: { id: influencer.id, name: influencer.name,
                        gender: influencer.gender, kind: influencer.type.to_s.downcase }
        )

        expect(last_json_response[:data][1]).to eq(
          id: moment2.id,
          begin_in: moment2.year_begin,
          locations: [{ id: location2.id, density: location2.density, latlng: location2.latlng.split(',') }],
          influencer: { id: influencer.id, name: influencer.name,
                        gender: influencer.gender, kind: influencer.type.to_s.downcase }
        )
      end
    end
  end
end
