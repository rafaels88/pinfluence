require 'spec_helper'

describe MomentRepository do
  after { database_clean }

  let!(:person) { create :person }
  let!(:moment01) do
    create :moment, date_begin: Date.new(1000, 1, 1), date_end: Date.new(1010, 1, 1), person_id: person.id
  end
  let!(:moment02) do
    create :moment, date_begin: Date.new(2000, 1, 1), date_end: Date.new(2010, 1, 1), person_id: person.id
  end
  let!(:location01) { create :location, moment_id: moment01.id }
  let!(:location02) { create :location, moment_id: moment02.id }

  describe '#search_by_date' do
    let(:search_date) { '1009-01-01' }
    subject { described_class.new.search_by_date(date: search_date) }

    it 'returns a list of found moments' do
      expect(subject.size).to eq 1
      first_moment = subject.first

      expect(first_moment.id).to eq moment01.id
      expect(first_moment.influencer.id).to eq person.id
      expect(first_moment.locations.count).to eq 1
      expect(first_moment.locations.first.id).to eq location01.id
    end

    context 'when no moment is found' do
      let(:search_date) { '1011-01-01' }

      it { is_expected.to be_empty }
    end
  end

  describe '#search_by_influencer' do
    subject { described_class.new.search_by_influencer(person) }

    it 'returns a list of found moments' do
      expect(subject.size).to eq 2

      first_moment = subject.first
      expect(first_moment.id).to eq moment01.id
      expect(first_moment.influencer.id).to eq person.id
      expect(first_moment.locations.count).to eq 1
      expect(first_moment.locations.first.id).to eq location01.id

      second_moment = subject.last
      expect(second_moment.id).to eq moment02.id
      expect(second_moment.influencer.id).to eq person.id
      expect(second_moment.locations.count).to eq 1
      expect(second_moment.locations.first.id).to eq location02.id
    end

    context 'when no moment is found' do
      let(:person02) { create :person }
      subject { described_class.new.search_by_influencer(person02) }

      it { is_expected.to be_empty }
    end

    context 'when a limit is given' do
      let(:limit) { 1 }
      subject { described_class.new.search_by_influencer(person, limit: limit) }

      it 'returns a limited number os moments' do
        expect(subject.size).to eq limit
      end
    end
  end

  describe '#earliest_moment_of_an_influencer' do
    subject { described_class.new.earliest_moment_of_an_influencer(person) }

    it 'returns the moment with the earlier date_begin' do
      is_expected.to eq moment01
    end
  end
end
