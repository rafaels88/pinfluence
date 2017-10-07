require 'spec_helper'
require 'hanami_request_test'

RSpec.describe 'API available_dates', type: :request do
  include HanamiRequestTest

  after { database_clean }

  subject { last_json_response[:data] }
  let(:endpoint) { '/api' }
  let(:influencer) { create :person }

  before do
    create :moment, date_begin: Date.new(2000, 2, 1), date_end: Date.new(2002, 1, 1), person_id: influencer.id
    create :moment, date_begin: Date.new(2002, 1, 2), date_end: Date.new(2002, 5, 3), person_id: influencer.id
    create :moment, date_begin: Date.new(2002, 5, 4), date_end: Date.new(2005, 10, 4), person_id: influencer.id
    create :moment, date_begin: (Date.today - 1), date_end: Date.today
  end

  context 'when no params are given' do
    let(:returned_dates) { subject[:available_dates].map { |d| d[:date] } }
    before { post endpoint, query: '{ available_dates { date formatted } }' }

    it 'returns date field as YYYY-MM-DD format' do
      expect(subject[:available_dates][0][:date]).to eq '2000-02-01'
    end

    it 'returns all date_begins in the system' do
      expect(returned_dates.count).to eq 4
      expect(returned_dates).to include '2000-02-01'
      expect(returned_dates).to include '2002-01-02'
      expect(returned_dates).to include '2002-05-04'
      expect(returned_dates).to include((Date.today - 1).to_s)
    end
  end

  context 'when influencer_id and influencer_type are given' do
    let(:returned_dates) { subject[:available_dates].map { |d| d[:date] } }

    before do
      post endpoint,
           query: "{ available_dates(influencer_id: #{influencer.id}, influencer_type: \"#{influencer.type}\") " \
                  '{ date formatted } }'
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

    pending 'returns the gap date in the returned moments as YYYY-01-01' do
      expect(returned_dates).to include '2001-01-01'
      expect(returned_dates).to include '2003-01-01'
      expect(returned_dates).to include '2004-01-01'
    end
  end
end
