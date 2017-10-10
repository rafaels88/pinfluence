require 'spec_helper'
require 'hanami_request_test'

RSpec.describe 'API available_dates', type: :request do
  include HanamiRequestTest

  after { database_clean }

  subject { last_json_response[:data] }
  let(:endpoint) { '/api' }
  let(:influencer) { create :person }
  let(:returned_dates) { subject[:available_dates].map { |d| d[:date] } }

  before do
    create :moment, date_begin: Date.new(2000, 2, 1), date_end: Date.new(2002, 1, 1), person_id: influencer.id
    create :moment, date_begin: Date.new(2002, 1, 2), date_end: Date.new(2002, 5, 3), person_id: influencer.id
    create :moment, date_begin: Date.new(2002, 5, 4), date_end: Date.new(2005, 10, 4), person_id: influencer.id
    create :moment, date_begin: Date.new(2015, 5, 20), date_end: Date.new(2015, 5, 21)

    post endpoint, query: query
  end

  context 'when no params are given' do
    let(:query) { '{ available_dates { date formatted } }' }

    it 'returns date field as YYYY-MM-DD format' do
      expect(subject[:available_dates][0][:date]).to eq '2000-01-01'
    end

    it 'returns one date YYYY-01-01 for each year starting in the year of the first date_begin to the last' do
      expected_dates = (2000..2015).map { |y| "#{y}-01-01" }

      expect(returned_dates.count).to eq 16
      expect(returned_dates).to eq expected_dates
    end
  end

  context 'when influencer_id and influencer_type are given' do
    let(:query) do
      "{ available_dates(influencer_id: #{influencer.id}, influencer_type: \"#{influencer.type}\") { date formatted } }"
    end

    it 'returns date field as YYYY-MM-DD format' do
      expect(subject[:available_dates][0][:date]).to eq '2000-02-01'
    end

    it 'returns all date_begin for the related influencer' do
      expect(returned_dates).to include '2000-02-01'
      expect(returned_dates).to include '2002-01-02'
      expect(returned_dates).to include '2002-05-04'
    end

    it 'returns the last date_end of all returned moments' do
      expect(subject[:available_dates].last[:date]).to eq '2005-10-04'
    end

    it 'returns the gap date in the returned moments as YYYY-01-01' do
      expect(returned_dates).to include '2001-01-01'
      expect(returned_dates).to include '2003-01-01'
      expect(returned_dates).to include '2004-01-01'
    end
  end
end
