require 'spec_helper'
require 'hanami_request_test'

RSpec.describe 'API available_years', type: :request do
  include HanamiRequestTest

  subject { last_json_response[:data] }
  let(:endpoint) { '/api' }

  it 'returns HTTP 200' do
    post endpoint
    expect(last_response.ok?).to be_truthy
  end

  context 'when there are no moments' do
    before { post endpoint, query: '{ available_years { year formatted } }' }

    it "returns an empty 'available_years' list" do
      expect(subject[:available_years]).to eq []
    end
  end

  context 'when there are some moments' do
    before do
      create :moment, year_begin: 2000, year_end: 2002
      create :moment, year_begin: 2005, year_end: 2006

      post endpoint, query: '{ available_years { year formatted } }'
    end

    after { database_clean }

    it 'returns a distinct list of all years from the earliest moment to the latter one' do
      expect(subject[:available_years][0][:year]).to eq 2000
      expect(subject[:available_years][1][:year]).to eq 2001
      expect(subject[:available_years][2][:year]).to eq 2002
      expect(subject[:available_years][3][:year]).to eq 2003
      expect(subject[:available_years][4][:year]).to eq 2004
      expect(subject[:available_years][5][:year]).to eq 2005
      expect(subject[:available_years][6][:year]).to eq 2006
    end

    it 'returns a distinct formatted list (with AD and DC) of all years from the earliest moment to the latter one' do
      expect(subject[:available_years][0][:formatted]).to eq '2000 AD'
      expect(subject[:available_years][1][:formatted]).to eq '2001 AD'
      expect(subject[:available_years][2][:formatted]).to eq '2002 AD'
      expect(subject[:available_years][3][:formatted]).to eq '2003 AD'
      expect(subject[:available_years][4][:formatted]).to eq '2004 AD'
      expect(subject[:available_years][5][:formatted]).to eq '2005 AD'
      expect(subject[:available_years][6][:formatted]).to eq '2006 AD'
    end
  end
end
