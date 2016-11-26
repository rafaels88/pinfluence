require 'spec_helper'

describe MomentRepository do
  subject { MomentRepository.new }

  after { database_clean }

  let(:influencer) { create :person }
  let(:moment_01) do
    build :moment, year_begin: 100, year_end: 310,
      influencer_id: influencer.id, influencer_type: influencer.type
  end
  let(:moment_02) do
    build :moment, year_begin: 300, year_end: 320,
      influencer_id: influencer.id, influencer_type: influencer.type
  end
  let(:moment_03) { build :moment, year_begin: 700, year_end: 750 }

  before do
    subject.create moment_01
    subject.create moment_02
    subject.create moment_03
  end

  describe "#search_by_date" do
    it "returns all moments ocurred in a given year" do
      expected = [moment_01.year_begin, moment_02.year_begin]
      result = subject.search_by_date(year: 305)
      assert_equal expected, result.map(&:year_begin)
    end

    describe "when no moment has been found" do
      it "returns an empty list" do
        assert_empty subject.search_by_date(year: -90)
      end
    end
  end

  describe "#all_available_years" do
    it "returns a list with all years since first moment until last moment" do
      assert_equal (moment_01.year_begin..moment_03.year_end).to_a, subject.all_available_years
    end

    describe "when there is a moment with no year_end" do
      let(:current_year) { Time.now.year }
      after { database_clean }

      before do
        create :moment, year_begin: 800, year_end: nil
      end

      it "returns a list with all years since first moment until current year" do
        assert_equal (moment_01.year_begin..current_year).to_a, subject.all_available_years
      end
    end

    describe "when there are no moments" do
      before { subject.clear }

      it "returns an empty list" do
        assert_empty subject.all_available_years
      end
    end
  end

  describe "#search_by_influencer" do
    it "returns all moments by given influencer" do
      expected = [moment_01.year_begin, moment_02.year_begin]
      assert_equal expected, subject.search_by_influencer(influencer).map(&:year_begin)
    end

    describe "when no moment has been found" do
      it "returns an empty list" do
        assert_empty subject.search_by_influencer(Person.new)
      end
    end
  end
end
