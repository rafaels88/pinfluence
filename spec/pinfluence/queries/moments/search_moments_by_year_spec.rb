require 'spec_helper'

describe Moments::SearchMomentsByYear do
  after { database_clean }

  describe '#call' do
    let!(:person) { create :person, name: 'PersonSearch' }
    let!(:moment_01) { create :moment, year_begin: 100, year_end: 150, person_id: person.id }
    let!(:moment_02) { create :moment, year_begin: 151, year_end: 180, person_id: person.id }

    context 'when year param is given' do
      subject { described_class.new(year: '170') }

      it 'returns a list of found moments happend in given year' do
        results = subject.call
        expect(results.count).to eq 1
        expect(results.first.id).to eq moment_02.id
      end

      context 'when a person has a moment with an empty #year_end' do
        let!(:moment_03) { create :moment, year_begin: 181, year_end: nil, person_id: person.id }

        context 'and current year is given for searching' do
          subject { described_class.new(year: Time.new.year) }

          it 'returns a list with this moment included' do
            results = subject.call
            expect(results.count).to eq 1
            expect(results.first.id).to eq moment_03.id
          end
        end
      end
    end
  end
end
