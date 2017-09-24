require 'spec_helper'
require 'hanami_request_test'

RSpec.describe 'API influencers', type: :request, vcr: true do
  include HanamiRequestTest

  subject { last_json_response }
  let(:endpoint) { '/api' }

  context 'when searching for :name' do
    context 'when no result is found' do
      it 'returns an empty :data[:influencers] list' do
        post endpoint, query: '{ influencers(name: "Socrates") { people { id } events { id } } }'
        expect(last_json_response[:data][:influencers][:people]).to be_empty
        expect(last_json_response[:data][:influencers][:events]).to be_empty
      end
    end

    context 'with an incomplete name as argument' do
      context 'when some people are found' do
        let(:influencer01) { build :person, id: 1, name: 'Dom Pedro I', earliest_year: 1000 }
        let(:influencer02) { build :person, id: 2, name: 'Dom Pedro II', earliest_year: 1100 }
        let(:event) { build :event, id: 1, name: 'Pedro War', earliest_year: 1050 }

        def index_people(people)
          Influencers::Indexer.new(influencers: people, index_object: Influencers::PersonIndexObject).save
        end

        def index_event
          Influencers::Indexer.new(influencers: [event], index_object: Influencers::EventIndexObject).save
        end

        before do
          index_people([influencer01, influencer02])
          index_event
          post endpoint,
               query: '{ influencers(name: "Pedro") { people { id name gender type earliest_year } ' \
                      'events { id name type earliest_year } } }'
        end

        after { database_clean }

        it 'returns a list of influencers' do
          expect(last_json_response[:data][:influencers][:people].count).to eq 2
          expect(last_json_response[:data][:influencers][:events].count).to eq 1

          expect(last_json_response[:data][:influencers][:people][0]).to eq(
            id: influencer02.id,
            name: influencer02.name,
            gender: influencer02.gender,
            type: influencer02.type.to_s.downcase,
            earliest_year: influencer02.earliest_year
          )

          expect(last_json_response[:data][:influencers][:people][1]).to eq(
            id: influencer01.id,
            name: influencer01.name,
            gender: influencer01.gender,
            type: influencer01.type.to_s.downcase,
            earliest_year: influencer01.earliest_year
          )

          expect(last_json_response[:data][:influencers][:events][0]).to eq(
            id: event.id,
            name: event.name,
            type: event.type.to_s.downcase,
            earliest_year: event.earliest_year
          )
        end
      end
    end
  end
end
