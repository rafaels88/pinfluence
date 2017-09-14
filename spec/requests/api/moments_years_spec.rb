require 'spec_helper'

RSpec.describe 'API moments years', :type => :request do
  include Rack::Test::Methods

  def app
    Hanami.app
  end

  subject { last_json_response[:data] }
  let(:endpoint) { '/api/moments/years' }

  it 'returns HTTP 200' do
    get endpoint
    expect(last_response.ok?).to be_truthy
  end

  context 'API' do
    it 'returns expected attributes' do
      get endpoint
      is_expected.to include :available_years, :available_years_formatted
    end
  end

  context 'when there are no moments' do
    before { get endpoint }

    it "returns an empty 'available_years' list" do
      expect(subject[:available_years]).to eq []
    end

    it "returns an empty 'available_years_formatted' list" do
      expect(subject[:available_years_formatted]).to eq []
    end
  end

  context 'when there are some moments' do
    before do
      create :moment, year_begin: 2000, year_end: 2002
      create :moment, year_begin: 2005, year_end: 2006

      get endpoint
    end

    after { database_clean }

    it 'returns a distinct list of all years from the earliest moment to the latter one' do
      expect(subject[:available_years]).to eq (2000..2006).to_a
    end

    it 'returns a distinct formatted list (with AD and DC) of all years from the earliest moment to the latter one' do
      expect(subject[:available_years_formatted]).to eq \
        ["2000 AD", "2001 AD", "2002 AD", "2003 AD", "2004 AD", "2005 AD", "2006 AD"]
    end
  end
end
