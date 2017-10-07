require 'spec_helper'

describe Moments::SearchMomentsByDate do
  after { database_clean }

  describe '#call' do
    let!(:person) { create :person, name: 'PersonSearch' }
    let!(:moment_01) do
      create :moment, date_begin: Date.new(100, 1, 1), date_end: Date.new(150, 1, 1), person_id: person.id
    end
    let!(:moment_02) do
      create :moment, date_begin: Date.new(151, 1, 1), date_end: Date.new(180, 1, 1), person_id: person.id
    end

    context 'when date param is given' do
      subject { described_class.new(date: '170-01-01') }

      it 'returns a list of found moments happend in given date' do
        results = subject.call
        expect(results.count).to eq 1
        expect(results.first.id).to eq moment_02.id
      end

      context 'when a person has a moment with an empty #date_end' do
        let!(:moment_03) { create :moment, date_begin: Date.new(181, 1, 1), date_end: nil, person_id: person.id }

        context 'and current date is given for searching' do
          subject { described_class.new(date: Date.today.to_s) }

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
