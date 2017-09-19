require 'spec_helper'

describe ListAvailableInfluencers do
  after { database_clean }

  describe '#call' do
    let!(:person_01) { create :person, name: 'Martin' }
    let!(:person_02) { create :person, name: 'Alberta' }
    let!(:person_03) { create :person, name: 'Lara' }

    it 'returns all people ordered by name' do
      results = subject.call
      expect(results.count).to eq 3
      expect(results[0].name).to eq 'Alberta'
      expect(results[1].name).to eq 'Lara'
      expect(results[2].name).to eq 'Martin'
    end
  end
end
